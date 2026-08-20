Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2671218EBA;
	Thu, 20 Aug 2026 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246963; cv=none; b=htV5mQ42YfNIvMRBmGs9SCQmD2Pt6Mz4dWSDNoIBqt5bHz7WtaseogkzTcl3Z5BC67ShBHsD0URF7NivItgM1BxjTN7ok3SUCWef1vFwVzLIdA7Z8uqwlZ0hwV08TdUmq5NzUVmw/O7kg9t2bzsdS4/y8rve0yPWP8bm/ZLJ0lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246963; c=relaxed/simple;
	bh=gpa6WNMfSCIaWStG5QZ6Eu+6nkV0hpI5F6YeJHgSk/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeTf7LipWpJp44PrNIg+vWOPXURaVMlvGeFKjaoUg7JhQYFISUhHuNDVcFDtpoqFLUdsjxvGx2SBN7qOchFIhtH1JYe+ZjbeU4RSGFkwQQDMOa6ZMNgw6eA+kxxy9ksUkffV+kU5Wb4jnbLriVEVC5Cqj31KawMTOVQkSy9BdlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCzNOMeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCzNOMeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8E51F000E9;
	Thu, 20 Aug 2026 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246961;
	bh=ebZ/GQ2qEQWceJVqHew7kiANMpXz+4Pp3WEIEQhy5FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCzNOMePVf1WKwi9OCUQqQgptTX8lDtly9GBaeRgiO10d8Oe5XVprWKoCCU65JoGv
	 fJMrJpsAz9mJTfw9DjNOjpfb0tLvSAbqMMfdLoJ/UHBh8lu7tkY/DccKvpJ+xPHOEK
	 6NRkaaXcYpPg/64uYFskfS5LtdA3ZoUXhJQ0qGZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefu Chai <k.chai@proxmox.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 062/220] libceph: tolerate addrvecs with multiple entries of the same type
Date: Thu, 20 Aug 2026 16:54:12 +0200
Message-ID: <20260820145225.352023297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefu Chai <k.chai@proxmox.com>

commit 5a87925539acecfe88229bad76ab81bd75a7e3f5 upstream.

ceph_decode_entity_addrvec() rejects any addrvec containing more than
one entry that matches the requested msgr type (LEGACY or MSGR2),
logging "another match of type N in addrvec" and returning -EINVAL.

Some admin tooling (e.g. pveceph mon create from Proxmox VE) generates
addrvecs with multiple same-type entries when public_network lists more
than one CIDR: it picks one local IP per subnet and emits both a v2 and
a v1 entry for each IP.  Monmaps shaped this way cause:

  libceph: mon0 (1)10.10.10.15:6789 session established
  libceph: another match of type 1 in addrvec
  libceph: problem decoding monmap, -22

No Ceph code uses the extra entries: since Nautilus, the userspace
messenger (AsyncMessenger) unconditionally picks the first address of
the requested type and ignores any subsequent matches.

Match that behavior: use the first matching entry and silently skip any
subsequent ones.  This is a compatibility fix for existing deployments
and does not enable dual-stack or multi-subnet address selection.

[ idryomov: tweak ceph_decode_entity_addrvec() comment ]

Cc: stable@vger.kernel.org
Fixes: a5cbd5fc22d5 ("libceph, ceph: get and handle cluster maps with addrvecs")
Link: https://bugzilla.proxmox.com/show_bug.cgi?id=7518
Signed-off-by: Kefu Chai <k.chai@proxmox.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/decode.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/ceph/decode.c
+++ b/net/ceph/decode.c
@@ -87,8 +87,9 @@ bad:
 EXPORT_SYMBOL(ceph_decode_entity_addr);
 
 /*
- * Return addr of desired type (MSGR2 or LEGACY) or error.
- * Make sure there is only one match.
+ * Return addr of desired type (MSGR2 or LEGACY) or error.  In case of
+ * multiple matches, use the first one for compatibility with userspace
+ * messenger.
  *
  * Assume encoding with MSG_ADDR2.
  */
@@ -121,14 +122,13 @@ int ceph_decode_entity_addrvec(void **p,
 
 		dout("%s i %d addr %s\n", __func__, i, ceph_pr_addr(&tmp_addr));
 		if (tmp_addr.type == my_type) {
-			if (found) {
-				pr_err("another match of type %d in addrvec\n",
-				       le32_to_cpu(my_type));
-				return -EINVAL;
+			if (!found) {
+				memcpy(addr, &tmp_addr, sizeof(*addr));
+				found = true;
+			} else {
+				dout("%s skipping extra match of type %d in addrvec\n",
+				     __func__, le32_to_cpu(my_type));
 			}
-
-			memcpy(addr, &tmp_addr, sizeof(*addr));
-			found = true;
 		}
 	}
 


