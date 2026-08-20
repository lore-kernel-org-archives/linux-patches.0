Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514947DFAA;
	Thu, 20 Aug 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247893; cv=none; b=iiQucTGUih37JspXySfW1pSpCYfCBkLt0fwaI6GqHMz/dyGF6jEyrssFjfERmReN48tvY1Gcyt7xuKvzGf6Fnr/6Aobi47NZYDjhHjCOhTstuD307DoVw5iR0hx2mxLSfqFrf4aA9arDAdyeeFAYBVhHNfo4bDcUDVDIgoymsyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247893; c=relaxed/simple;
	bh=7Yb92gtV+tFfDXAy7C2mRtwQ6DrATNuVfHgMRxawWSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueUnDBGjXl6Ra1cE58HthZkIjexFjJzqLTT5Dy69hlvzix7CJ2d8ton6pg0hQ+yibE1mgGiNTdApJjAYwP6wnYDHhNfRhMP5ixK8QNQ9KO4t31zttX1wP83v6V+vejZ+n6N5KQ2IfbAOehiq/6gF5NXAnR9Is9F7othp41k9rhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdr9PErA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdr9PErA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C27B1F000E9;
	Thu, 20 Aug 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247891;
	bh=xrex6wpzvUS5b8mC90JY3bBjmvhycJTKOFvV+rjZ35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdr9PErAAnlPlP9/xylD5M7PWIQf3slYxxkXjLu77MqhyQaXSBokuIUvdeM089aF0
	 A0TUGOs2ZnUHPzHVa/1FSTR9vb2KEVF2T0TggSTH/BgCchKGaxmh0rrAXXYV1aIWTr
	 NavtYvDexaxpcZjzhMQ2o8W+cAPFCCmW1jKvfRok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefu Chai <k.chai@proxmox.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 038/303] libceph: tolerate addrvecs with multiple entries of the same type
Date: Thu, 20 Aug 2026 16:52:54 +0200
Message-ID: <20260820145254.329268485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


