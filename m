Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E23BF2E8;
	Thu, 15 Jan 2026 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496793; cv=none; b=LYI8HkBBnrUjBh94dJ2JMiiiiGf+0oAm/o+HbKvDHk23YqzgUN2XllnzqtizSwEd/MiZ3TyRehz2J3ppFwBzN/Pw8Sb/GmvTush45D/CAN5Seog9u4ZKcmi2XBOKiWkz8CGmEkKbcASXnCmGAbVYKMb6ZtgK96PvRZw+Xa75hNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496793; c=relaxed/simple;
	bh=Po2zZdTll1sSYjvi1umm2DAEQfMP0beYAd1+hw/Pe6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrupC3dmvX+kR9uUFLNO5NQbykIgo3Ge9EV+AcjEnhpIBoVELPfutt8gFMiOKSv9VFWj+zojIvdqVavoc3Lb6x21r94Eu3dD9Uj3nFRsOxvkXnqIWfT6/g6J6/mYUqlNmyd4XDMV/nFhldCYc8IXYZcqK/ZaO3M2/KUR56jv9UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTE4OJY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTE4OJY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F229C19422;
	Thu, 15 Jan 2026 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496793;
	bh=Po2zZdTll1sSYjvi1umm2DAEQfMP0beYAd1+hw/Pe6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTE4OJY0t9c8EbO/Rmz3lNfRLKR4Nno4eqGKH/Sx9nuprjtDAJukbqMYafF2M1/Ri
	 eg+eZS6C4+NRXEWmCN+Vac3sVNM18WmGjl8SlyowJeOePWXmEnx1Cl5Cht1t+Dfnyq
	 fRGHqN/S5n7zhV35oGJrwktESRyLwkmZ8Vvhirqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.6 18/88] libceph: return the handler error from mon_handle_auth_done()
Date: Thu, 15 Jan 2026 17:48:01 +0100
Message-ID: <20260115164146.976240827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit e84b48d31b5008932c0a0902982809fbaa1d3b70 upstream.

Currently any error from ceph_auth_handle_reply_done() is propagated
via finish_auth() but isn't returned from mon_handle_auth_done().  This
results in higher layers learning that (despite the monitor considering
us to be successfully authenticated) something went wrong in the
authentication phase and reacting accordingly, but msgr2 still trying
to proceed with establishing the session in the background.  In the
case of secure mode this can trigger a WARN in setup_crypto() and later
lead to a NULL pointer dereference inside of prepare_auth_signature().

Cc: stable@vger.kernel.org
Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1417,7 +1417,7 @@ static int mon_handle_auth_done(struct c
 	if (!ret)
 		finish_hunting(monc);
 	mutex_unlock(&monc->mutex);
-	return 0;
+	return ret;
 }
 
 static int mon_handle_auth_bad_method(struct ceph_connection *con,


