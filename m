Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2771222323;
	Thu, 18 Jan 2024 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575157; cv=none; b=bgO2tKKNhAk2IWqWrVXh7+bdGWk8Y9ItM8L9O8jyfSdy1fP9HXXvMBRxJCMemnk+My/YlpHbOkYTHv/QgYU6Xm7I45YeY82SucmaHJt0wInQv5L5jLPbVhUUKOnF+UjPCaeK1KzbxaWXcrinTCVOcoE51A3LN73+3qBhm0ATNNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575157; c=relaxed/simple;
	bh=XWBHz3gBz63mgBBfcaX8MaCOgOqDyYHH2aLJwxs48F8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=cPeamN7CsXquZAlogj/2eUcM73dZO/ZQ+5o1k2/u/I651513kpkncMFbCXO2tHWdEVbgw9qiqJTFtzRLiN5mOc0tuN2Phs0WtWeHMFrBVhNH6S0P91d0xusTE+8NVPoRalajFmoj2y3nqDJ8YgAPMEORTQh77VQWx284d01rd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imZ2nUPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imZ2nUPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F966C433F1;
	Thu, 18 Jan 2024 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575157;
	bh=XWBHz3gBz63mgBBfcaX8MaCOgOqDyYHH2aLJwxs48F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imZ2nUPQwaqZZY9ObZZ53cCgFJz3UtHEcLvvo0hvKlK/Sl4dnZc5s3oYrGbllXCB8
	 qrKu8osi0uxNbZBtWqdW/0i1oGeeibOz++2/e1Ob4J5ItiPv1dtaJTEJTaOVTDTbP3
	 +npWPmKzLYyWPBOYhfxGnnlMngarrU+UKcxNr9us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/150] mptcp: fix uninit-value in mptcp_incoming_options
Date: Thu, 18 Jan 2024 11:47:09 +0100
Message-ID: <20240118104320.377766458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 237ff253f2d4f6307b7b20434d7cbcc67693298b ]

Added initialization use_ack to mptcp_parse_option().

Reported-by: syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index cd15ec73073e..c53914012d01 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -108,6 +108,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->suboptions |= OPTION_MPTCP_DSS;
 			mp_opt->use_map = 1;
 			mp_opt->mpc_map = 1;
+			mp_opt->use_ack = 0;
 			mp_opt->data_len = get_unaligned_be16(ptr);
 			ptr += 2;
 		}
-- 
2.43.0



