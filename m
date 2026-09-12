Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61412D8382;
	Sat, 12 Sep 2026 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200194; cv=none; b=hkOGpOtbAi1To+odTNYUojsBVv3X0DJTV1KmJxqPSwHml05A/FJtymplw2AzcJEvKmch7OSyw58nvzCoPTJjnX0P7rQzVrl+5PEvO9Y6MyDYXplScka0BPSDRY7/2ppkDdGab4pDxIFfNO+4EOoTYrUX6w4DwBz+kNGsH4F+c34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200194; c=relaxed/simple;
	bh=RgYibpoY5m/1nyYB1VMbby/H4PtsAyCZpCAvqsuG1gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDYVhdk5aQj9nA9fLDzVF5oP61K2FuSXx0GHhymSRGiJFXT5cSZz5CREGwXBmqTxtM+n8yQmb9T1/Onuh43JgO19Ua28Swu9e+LdAJvKqxCUHUDAKRrq9VDZfJh3stQ0647pmkOFM7vVjIfZ5Rl3u6pJ5SfBJHgsbnFbwAnUNEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZweWBex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZweWBex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEA91F000FF;
	Sat, 12 Sep 2026 08:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200193;
	bh=YMLL2+3t0umzUsOqNVnqou4BHhz18JbxRvHK781B3Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZweWBexlGVDzTHNOLCK5I6AhzznlyHQTf+HyWBwW+ViyNftavWgozLj52k2UeZ0m
	 04epPZqpMneVBUUZDWKpbWJCWyR8bFMbM2z0qfnvKaVJSGwICL24UgmycXlB0MRtu9
	 yqDaZer7hQsfBbRCuUR1/FbuzxsFNR0zxlcvdQnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0741/1815] nvme-pci: return error when parsing a quirk string fails
Date: Sat, 12 Sep 2026 08:41:31 +0200
Message-ID: <20260912065706.301818047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit df74eaad001cf669c332dc67ef91996532e6b52c ]

quirks_param_set() reuses 'err', which param_set_copystring() left as 0,
as the return value of the whole function. When nvme_parse_quirk_entry()
fails to parse a field, the code jumps to out_free_qlist and returns that
stale 0, so a malformed quirks= parameter is silently accepted as valid.

Set err to -EINVAL before jumping out on a parse failure.

Fixes: 7bb8c40f5ad8 ("nvme: add support for dynamic quirk configuration via module parameter")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d094717c17a01..219cda2558284 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -213,6 +213,7 @@ static int quirks_param_set(const char *value, const struct kernel_param *kp)
 		if (nvme_parse_quirk_entry(field, &qlist[i])) {
 			pr_err("nvme: failed to parse quirk string %s\n",
 				value);
+			err = -EINVAL;
 			goto out_free_qlist;
 		}
 
-- 
2.53.0



