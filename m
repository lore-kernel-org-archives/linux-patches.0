Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F301145B1A;
	Thu, 11 Apr 2024 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831076; cv=none; b=Vrm7eOdGkWPuMnbUfDzfm1LU0ZH6RAmgufblaVEvUWBkBYUyRrW9Cd6upMzZ0hCrrHZSwWh2C8ztrIaWOWCmYsjSBA0i5pkt7aBKONCPo8MmN/zhqJ52XFLHuKICz9ZQ3qup3LZ6t6RRUv9/u7qflBiruqObYTkYsyKMzxDz/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831076; c=relaxed/simple;
	bh=RA+e22XWW9HiXLzEXpECSi/XckXvBdmbwq8nS4S3p8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtXPOvk84qa1SqnnkhB8NdGlKYHyIQjG2bLhZW0D+nR4xaHfjfT/s6QaUYjeRIbW7b0aRmjjKWZ0m+3QWBI7vvoVE/zCR2aJbFW+ytqer5lIMMnpYGns42ZGjIjsHigJa5l8DFm/VeH8nTc85AB4nbvGRaJb1TJnbuDg6P0wJZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKgyZFyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKgyZFyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800BEC433C7;
	Thu, 11 Apr 2024 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831075;
	bh=RA+e22XWW9HiXLzEXpECSi/XckXvBdmbwq8nS4S3p8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKgyZFyW2fvKmhTJzOyLkNnBT1XeQTypCFVoD8USLU/hUcV7vqUBAg4qyryvz5ANH
	 Z1fgbHQ88tGGuLKQ/vFOF/AtwJdW1Rgue0IhMzhdWC7zQlBh+lNttDr+gcdbfUBhPe
	 v7np8BI/aPkjnuyV23z5eHRIDrW0mBf0N2C2lAQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.4 215/215] firmware: meson_sm: fix to avoid potential NULL pointer dereference
Date: Thu, 11 Apr 2024 11:57:04 +0200
Message-ID: <20240411095431.324173590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit f2ed165619c16577c02b703a114a1f6b52026df4 upstream.

of_match_device() may fail and returns a NULL pointer.

Fix this by checking the return value of of_match_device.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/tencent_AA08AAA6C4F34D53ADCE962E188A879B8206@qq.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/meson/meson_sm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -302,6 +302,8 @@ static int __init meson_sm_probe(struct
 		return -ENOMEM;
 
 	chip = of_match_device(meson_sm_ids, dev)->data;
+	if (!chip)
+		return -EINVAL;
 
 	if (chip->cmd_shmem_in_base) {
 		fw->sm_shmem_in_base = meson_sm_map_shmem(chip->cmd_shmem_in_base,


