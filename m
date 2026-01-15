Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD6E1C5D59;
	Thu, 15 Jan 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496094; cv=none; b=mgre10UPALanbwWE5C7z8+immdi+PjKvbDN7Su+qivCSbU+6e3tf1Zkdkuxb2tzjM1FcM6Vcdjd2xVlT73U9WrqFm+3lsKh7g5pP3JoxXhziNGUtNrCUzQpp694ttBoHC/Wk2Qzp3rF7yHh2PkDDlUqn6Velm4Clb9/nXQ36t+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496094; c=relaxed/simple;
	bh=hZhky6i+lnlgMjHpawWIuYRccG2kUkmeMMOxqFsBzMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6qHa23O1R0cL+IAX9X84vgPGmtF02UKMaGhwljHQjSEUaVDEdCqftufE0JiI8Vx8qYYIwSKnf0b18p6rnv9R8XA0mPfRBycFaHbUBmthBVm3sOpDtK0rMYqhnBIU+FqnXW3X+ZcbRvuUJuBnf6RHeZ/sjL0wHDTTUiTTHyY6XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhwbLd0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhwbLd0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D9CC116D0;
	Thu, 15 Jan 2026 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496094;
	bh=hZhky6i+lnlgMjHpawWIuYRccG2kUkmeMMOxqFsBzMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhwbLd0S6Ay/wyFuJ2W53Ar95i3l5jjn9ilPPETgatjgfBzC5NpbEcp/aprnoMdGu
	 mcDK6PsCHsITXzMPm5qF9rwYvxb/KImydyVH8zt0mBwlSYCnG+GIROu5wL51ExrRkm
	 u5G7OPJDSncauKjpNs1QPfDEX4Od99JL113Yt1qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.18 042/181] libceph: return the handler error from mon_handle_auth_done()
Date: Thu, 15 Jan 2026 17:46:19 +0100
Message-ID: <20260115164203.847572576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


