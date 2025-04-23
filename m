Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746B228B4EA;
	Wed, 23 Apr 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420997; cv=none; b=F2Cb60zaxXcXg1AYtV2GfZ4ypZMHbpldWG0dmOPJttRcR1e034Zzh+GLjASTUP0cil/Ok736H4GNuAqRCGH8Dgr/JCPusSgwGybY8FU6BUXE88oIfY+yF2xqaz1uKp6eSX0Ox+NpEOT4pEKTrLHObCAcUOlEe9C/sxH+tIN74vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420997; c=relaxed/simple;
	bh=KHLhcfGEdUOL9njV4uB8AoVA4wrOFE2BjdJTOq/GWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxlsnIMhlHMM4aBfCrq5s6hQopmvcKKKLHH1Cz747aPRvq+ocyIfdvXIbCzOxfIbBnNdTxsl+s5Kvcv/iVTOfHwmVq2DmAnPPsiuowBbFMjTLazg10UQZrIssY0ofLEoQcP6rID71R+alLreZiIsXidYx8IlufF7wz4+DD9xZHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcrBGc0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcrBGc0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D21C4CEE2;
	Wed, 23 Apr 2025 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420997;
	bh=KHLhcfGEdUOL9njV4uB8AoVA4wrOFE2BjdJTOq/GWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcrBGc0Rh59YDUSSFrVOI4F3CNWW/PB6tlKmgS7fOvl/euRY1yRgu+wQzBmRJR+m+
	 +DUuZkrFsjESu/4JnYXaCereAkiS1QwiM13AKh1k2tIdQ7QuWQwUEXytAYSk3edX24
	 WDnEp1iecIlKGAJ/ArqwjYzn2I++0SdNuQ9ixtU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 099/291] media: venus: hfi_parser: add check to avoid out of bound access
Date: Wed, 23 Apr 2025 16:41:28 +0200
Message-ID: <20250423142628.398549540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 172bf5a9ef70a399bb227809db78442dc01d9e48 upstream.

There is a possibility that init_codecs is invoked multiple times during
manipulated payload from video firmware. In such case, if codecs_count
can get incremented to value more than MAX_CODEC_NUM, there can be OOB
access. Reset the count so that it always starts from beginning.

Cc: stable@vger.kernel.org
Fixes: 1a73374a04e5 ("media: venus: hfi_parser: add common capability parser")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -19,6 +19,8 @@ static void init_codecs(struct venus_cor
 	struct hfi_plat_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	core->codecs_count = 0;
+
 	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
 		return;
 


