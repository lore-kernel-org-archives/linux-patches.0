Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1EE350847;
	Mon, 18 Aug 2025 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525941; cv=none; b=SORd0VLt5CCYDJ0R/xLszhFArKW3ATb5aLcqvquFMiSIrSFnYQcg593uexPtN8BWOMRFJwWV8nlM5HY03xwEA8YPMgqI+m8wEoG7pUmGct6ywmU30lcDJM9EO7O2sCu3tjkXdXpIxPzVu/7rzFBGQfU5sAAUp1o0c122jpgyhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525941; c=relaxed/simple;
	bh=WFhR6vpY7XCEOQH2sFgURz2Lv9Ktc9SVvokHPibCTCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mraMm72xzJ2bH4LntwC6uk50U6Mf+vegik7mDJ0FrJStzpN2BeGrNsmlZvPwa2WF7pQfE4Boaab/GZCffiUPJVHGf2P7VxkJkke6YCB/t+XwdoOMJ03C7kyGw++5UygraudUBTG/rglAyq1zj/Tz0xlH0Nw9PIjdC8O9uakV9eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSVhKxTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSVhKxTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E840C4CEEB;
	Mon, 18 Aug 2025 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525940;
	bh=WFhR6vpY7XCEOQH2sFgURz2Lv9Ktc9SVvokHPibCTCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSVhKxTo/Cg34W2IT7oRUS4fT9eGXAu7N1QRYY2izkRACq60FE4gcwgrfLc7G2JHA
	 BcHdkWA2yBGMWpwpGP1hyJ75y3DJNSUr4A15vbXayc2v9DTH3sVVcQt3arclLT/J8s
	 WZQDC47kp0vvRqFFyFV3m7fVIlU6+ujPB9Ht+mrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 378/570] scsi: bfa: Double-free fix
Date: Mon, 18 Aug 2025 14:46:05 +0200
Message-ID: <20250818124520.415297169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a719a18f0fbc..f56e008ee52b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -706,6 +706,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5



