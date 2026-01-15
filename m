Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5398686334;
	Thu, 15 Jan 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498662; cv=none; b=ODub4rzOTGp0cBGh4VdF9ufbF4xceQH8ou/3emyAW7eyVslK1KjpyNxjiCR5Y0cKBO20h0+e4f2E54AYxcxJxBAMqSard+2h2YA1frq1XLlG93x+7DOTb1kOiEkoSd8Adr+tgfpUCiaw+uVpCqB9W3f9Rvul5aYUkTCiWbyS39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498662; c=relaxed/simple;
	bh=xF7W17tgLlqq2OHXCd6PkBf8KHfLBp9HIpkpUdCCkWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ8etEzp4JpE3hwzU+4LXDcoGVbWjRLqvk8D7wsqcrjiOynMLNg0L5g3RTvBYxsfrUFkgEA6+sCZnx8lFD64JTtL45VHO4EjL19UzreOtj8nz/l72tI3BbN6KfLWw9trp5bYlsJMbcFJV8Gl13/CL3TbQb1wnNtY14lGPKw4PIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kU6YnuRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kU6YnuRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D84C116D0;
	Thu, 15 Jan 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498662;
	bh=xF7W17tgLlqq2OHXCd6PkBf8KHfLBp9HIpkpUdCCkWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kU6YnuRkRBSlqzR66bEsu/iFssqlMUE8SxDflRgkbAAP+VQD7U8XQSgTuX0nUjW7y
	 KGbcup8YaA1x6zC8S0qpw3G2CJ9avdB8MpmW7yLzffyeQGINTvZ2a8l+6HV2z6znAs
	 HByeNU0ZsP/VX+e5nuN5uJlb30wULomJK/6iDdOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 5.15 510/554] libceph: return the handler error from mon_handle_auth_done()
Date: Thu, 15 Jan 2026 17:49:36 +0100
Message-ID: <20260115164304.777029735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1418,7 +1418,7 @@ static int mon_handle_auth_done(struct c
 	if (!ret)
 		finish_hunting(monc);
 	mutex_unlock(&monc->mutex);
-	return 0;
+	return ret;
 }
 
 static int mon_handle_auth_bad_method(struct ceph_connection *con,


