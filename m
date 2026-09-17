Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02EE4F85B4;
	Thu, 17 Sep 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668194; cv=none; b=a+Y5+ssGmgySNgu8xg2EmhM2nX1AsZ7XxhioAG2fXQ+VTO+xts0trWtyhyyO/+7Ym1oh6qo9yO0iSVI1c0QnYKBn2BCTuJAvMkeZmTzK+iteFLskpkgQImnoFblr61W+vqYqi1TL0WjI7dHE8sTJRgx8ycVMbQmyo/ZY9fEu/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668194; c=relaxed/simple;
	bh=1S3VVEnetwjvryZY5R6DN+7k4Vdsqdx3D0rS9bY+qWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAp9nGGNAbiE0Eb/QgPL05prAEtFSZlhQjGHYu7A/smF6KH1BQXHfyL1IM6Z7U/fQwFG4mzedGgAbvYSlEoWBCHsFdkWZxB7uelobLxUn+zp+JJkTcmjInOPZmSWbrpRvoGcJghmz7NvaTCASEkYPbVMUAVg0TOS0jdo58KH7Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkLPnKln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkLPnKln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ED01F000FF;
	Thu, 17 Sep 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668192;
	bh=oDGinCHzbxjEUFa2QHJM0jY4Fl/fQ47bvUX0gPVrHAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkLPnKln+UYcSdby5TmUIn4x2qyQ61jILEuc1XpIpHIlJnxLsV8ON92zMFB2dN8Op
	 HZzFpwoyNnU78Rlg/jDX07xBK8N7x5O1W5HXA9p6XZhVLcefIG9RjjSp1THYB1lPyn
	 T5ReNKZdm5DRQl1eisNdpeXzwXQJsuvc50Vh7jHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0344/1102] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Thu, 17 Sep 2026 16:04:47 +0100
Message-ID: <20260917151548.276724353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dea608e65c413..bd97efd7393f9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -996,7 +996,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0



