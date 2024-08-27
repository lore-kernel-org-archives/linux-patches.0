Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B4F73466;
	Tue, 27 Aug 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770597; cv=none; b=bYUV3zqLQNxFpTBu4Ieygq+2qWRgy0MjD4PprtIyd+NljqNC6iK/tfjbNyLUEbcarrbZAKi7a46Gq1crE+kLTjnL4Jw6DGATp+PUBynSSTwjXYctxKxNtQGriaSgR51Ibxl5oiDdGoEm2KuwCf4/0dnyzIReZFoSk8X1qARWupE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770597; c=relaxed/simple;
	bh=F17fGsknjvZCzxIciYeHBtbtDx5gZlW8eq+FdgyISbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkcedTf7dLHs7H3DkuEnoau/dq9JJbCcecS7tquNnfGVwxkqxDT6d3/AU3y6aNFXJcFWhQ5ROJvyHf9Q5KUXCHclUHVjNXltoIrXywREEWZOLNUpWFM1O6uQqYDLTV8WkKa+iIyjiVWvDASjpqiyFh2hyAEPVYBORy430EPH3Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6gSKCpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6gSKCpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D31C4FE02;
	Tue, 27 Aug 2024 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770597;
	bh=F17fGsknjvZCzxIciYeHBtbtDx5gZlW8eq+FdgyISbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6gSKCpWhYzgjiDEWahjHZHj1k+R05gtWFnJ7ymWdk8N1HijlfVPB9Ozh2DXoODMV
	 O9EUL420WVqkIPt/dcKHw03dnGIPj7CkJ7vfPw7mTzsF5Mxu8PF3bG/ePRDJOBGDi4
	 NhXBYHidCfmZUXCuGz+qL/qzAzvmr5vRjrJhsTIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Adrian Moreno <amorenoz@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/341] net: ovs: fix ovs_drop_reasons error
Date: Tue, 27 Aug 2024 16:38:27 +0200
Message-ID: <20240827143853.902658375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 11c69415c6052..b7232142c13f8 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2707,7 +2707,7 @@ static struct pernet_operations ovs_net_ops = {
 };
 
 static const char * const ovs_drop_reasons[] = {
-#define S(x)	(#x),
+#define S(x) [(x) & ~SKB_DROP_REASON_SUBSYS_MASK] = (#x),
 	OVS_DROP_REASONS(S)
 #undef S
 };
-- 
2.43.0



