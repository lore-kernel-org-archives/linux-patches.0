Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210D1C6893;
	Tue, 27 Aug 2024 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771447; cv=none; b=o25dZvUtJaQ4fWaOGXTvIB6Gsa45qqcwjEBe/JxJ6+SUDCOPvjIBrmdBObSnqg4WI87H9S5VhqPyeLkZFrboNSoYSdbNSfxIekwIspWbwezI3HE+Kf8X0p5wKB3NmgFJDd0xqrFvaS1d4S13AXOj080hoRsL6i5wxxSuepN73LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771447; c=relaxed/simple;
	bh=xFm0YtqSamCuKFHE4A2ZN/sETHVAwy+tT+rPLQ7b2uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4n4Q6wz7uptncLDqG3Jrstrh4VWEsHqrPvzIoKqXx6V28gOrhk7lnSLqZb9Go67YS+E5xl5hwxvzihfSE5rl749sJxOpUxH67U5yHKonJlVAiun8ZnxFMo8+MQkV0kfJAZJfOFmE6VaUPWxRa4h0Fq//538fXHCU0fKUWQstis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUO14Bl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUO14Bl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08131C4DDE4;
	Tue, 27 Aug 2024 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771447;
	bh=xFm0YtqSamCuKFHE4A2ZN/sETHVAwy+tT+rPLQ7b2uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUO14Bl+QRt91Zs87JYflablIM2Xc0a4k1cViku0SYSsSNjN8Qc+pt77W0DR8Q5+1
	 fG1kvbMIdoehn38vYPeX2N27CQvb3hr9LI0N2OETrmIctTkq6OIQyATM4Tn9/jsdlH
	 TDK5DjuUeaxO7+mcjXYBOpFDcPPHIzA2vZjBwK7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Adrian Moreno <amorenoz@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 190/273] net: ovs: fix ovs_drop_reasons error
Date: Tue, 27 Aug 2024 16:38:34 +0200
Message-ID: <20240827143840.637947217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 57fb67783c4011581882f32e656d738da1f82042 ]

There is something wrong with ovs_drop_reasons. ovs_drop_reasons[0] is
"OVS_DROP_LAST_ACTION", but OVS_DROP_LAST_ACTION == __OVS_DROP_REASON + 1,
which means that ovs_drop_reasons[1] should be "OVS_DROP_LAST_ACTION".

And as Adrian tested, without the patch, adding flow to drop packets
results in:

drop at: do_execute_actions+0x197/0xb20 [openvsw (0xffffffffc0db6f97)
origin: software
input port ifindex: 8
timestamp: Tue Aug 20 10:19:17 2024 859853461 nsec
protocol: 0x800
length: 98
original length: 98
drop reason: OVS_DROP_ACTION_ERROR

With the patch, the same results in:

drop at: do_execute_actions+0x197/0xb20 [openvsw (0xffffffffc0db6f97)
origin: software
input port ifindex: 8
timestamp: Tue Aug 20 10:16:13 2024 475856608 nsec
protocol: 0x800
length: 98
original length: 98
drop reason: OVS_DROP_LAST_ACTION

Fix this by initializing ovs_drop_reasons with index.

Fixes: 9d802da40b7c ("net: openvswitch: add last-action drop reason")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Adrian Moreno <amorenoz@redhat.com>
Link: https://patch.msgid.link/20240821123252.186305-1-dongml2@chinatelecom.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 99d72543abd3a..78d9961fcd446 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2706,7 +2706,7 @@ static struct pernet_operations ovs_net_ops = {
 };
 
 static const char * const ovs_drop_reasons[] = {
-#define S(x)	(#x),
+#define S(x) [(x) & ~SKB_DROP_REASON_SUBSYS_MASK] = (#x),
 	OVS_DROP_REASONS(S)
 #undef S
 };
-- 
2.43.0



