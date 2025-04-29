Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07899227E95;
	Tue, 29 Apr 2025 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948670; cv=none; b=C9UgzCHLhBviPP9uZdTvXva4ldLvdWEbfWi2Xyy+C9q+NpJ1ZzYX/3Ami1/+RBQJhsf+aiQhCtKGyia3Zk1YnqFZkNFfIcnBSx8xRZxz+QBYYvdftPKK5VEYBrvtoczsVmoLOGeCk2zUhJruizXzW8q4ReX37453uDONv6cGg80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948670; c=relaxed/simple;
	bh=NfBt+nbUkQLw9tGRKT2jNov6Svk5DXU8hNbUNf4x6mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlTkNTjQUy8REsmuIwL4LdZfsQDGHwVu3GqQg498RaOF/ShT2UncVlxxDqtIwNjfQMOItapD6U2Ve43oer+h3zwlPZkak3hgqPbuW1lXmCTvruEFUMVtaboIEjV/2lWpmtoaaInWFtTOqPyjxPDxuMYcl7zuY7abJuxLujI9YTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfD4AJWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfD4AJWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F092C4CEE9;
	Tue, 29 Apr 2025 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948669;
	bh=NfBt+nbUkQLw9tGRKT2jNov6Svk5DXU8hNbUNf4x6mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfD4AJWcLDTigj3RBSmvE/C5f73Rt72mL0EbCo1CQJY/kqEkd0PXZ5HoL4l7jRcFP
	 iULivcfeZE7ZfvW1N8LsWcbajDo/SZ/JHF7xLczYnysV73phK7PmqUiv+8+V4TKwmh
	 Fpb4YqjtAL137OAaUCfp7zzxvH5AZMSxJvIc1uuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 076/373] media: venus: hfi_parser: add check to avoid out of bound access
Date: Tue, 29 Apr 2025 18:39:13 +0200
Message-ID: <20250429161126.282117190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


