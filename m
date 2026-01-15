Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7502C028F;
	Thu, 15 Jan 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496474; cv=none; b=Q6NkjMqZF2uLQKCfkaLFjPecVBlx+mdL/9bKPuaqYwS6/uC5uSD4shaqqg4hfXLdxnJ8zSlTsOYffY1BNoTtl3mCgRcU26MppCoWOPR7UKddtssQVdD/athkqqSC3wWeO62YrDH5hSupl2OzgWNJks7yZbwva11SIBUWyHyAiJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496474; c=relaxed/simple;
	bh=WZNI9CXr5ZSZ/msh1g5THZKMzuLLIOhT+SrSWDcDLSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUEgqtbqAocxu/X0ku+W0VqElUn73PZU+EF6MsSlwhNLFLAmxmRpSDlJBVtEPCOGPI4jkvfbrcR2+etof+/89iWuoGLFfXwlxdpQGK7ere8S/LTXSNrtCSD1/Oj1TRH1ajIw9EzgiCJ3TKXyiXmxJINJL+q08gEe5mrlWNUU3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCjVSuA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCjVSuA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32059C116D0;
	Thu, 15 Jan 2026 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496474;
	bh=WZNI9CXr5ZSZ/msh1g5THZKMzuLLIOhT+SrSWDcDLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCjVSuA5RJiv1wZ4Bg3N7DgKsfIC8gih0hU8pMnDIcE7pNIzmmDFM93G/BeTQ9EKg
	 dWA6H/h+eKXbqHapuJ7OGQ0q4iry8q1FLPBWILJcWpH7MeMxw3erI907DI66d6DSmG
	 KJNPyQWsnpxwOZ5olJ+ugG8AJetP5cdSOBMlXQU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.12 025/119] libceph: return the handler error from mon_handle_auth_done()
Date: Thu, 15 Jan 2026 17:47:20 +0100
Message-ID: <20260115164152.870282835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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


