Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350313CA93;
	Thu, 12 Dec 2024 17:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024115; cv=none; b=E5DWncZi95F1SDuGFyINqzTVwgIyvcICzanv6p1kxUCqwmngU1ZCWfYAQC6jSr6lOm11Ff6xmk4vQXKrJaV4HlsW9UAAifn4gsbk3Q98KNROD5FwvJX7JWgCzBj/YifhkXcIiJkSplRtLPPJtRw1Q0jbnKc3BMglId7PLGhqZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024115; c=relaxed/simple;
	bh=i3lN6kFz+RVaTInW9tG6PfliiPEjnen5juS0/O0M2Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnwNKoKjG9dB/LfLVEbXYk+1Xmd+T92qI9DYZny5DaO/OXMTMp6jjrjZQAuxh5qthMA3C5uaUvLHI5QK3f4L3tte7DnsTALNc38EK7oj18HkF86PAyrc3XC3ed41Sn8YaOauCt2vQuM3NRFIOWPPkBOqigbfSHeaWy/yt5Ja5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KELj014y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KELj014y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F17C4CED0;
	Thu, 12 Dec 2024 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024114;
	bh=i3lN6kFz+RVaTInW9tG6PfliiPEjnen5juS0/O0M2Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KELj014ywCwyNAGZCqRVxg6cNi66ZzkZ3Y1W9lhqKsGRigNWgWINT7PZB+DmWoWDg
	 OJ8BxiwBdKXmmnhxjJjlLwvVdU2L1S3DY60+nQtmhRvGeGXm/Zv41VCh615l1+Olwl
	 DSHmpAaZc3y3xHPSVKDFYZ0hZGRjxC/meqwkvbeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/459] powerpc/kexec: Fix return of uninitialized variable
Date: Thu, 12 Dec 2024 15:58:41 +0100
Message-ID: <20241212144300.786427349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 83b5a407fbb73e6965adfb4bd0a803724bf87f96 ]

of_property_read_u64() can fail and leave the variable uninitialized,
which will then be used. Return error if reading the property failed.

Fixes: 2e6bd221d96f ("powerpc/kexec_file: Enable early kernel OPAL calls")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240930075628.125138-1-zhangzekun11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index a8a7cb71086b3..cb3fc0042cc25 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -909,13 +909,18 @@ int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
 	if (dn) {
 		u64 val;
 
-		of_property_read_u64(dn, "opal-base-address", &val);
+		ret = of_property_read_u64(dn, "opal-base-address", &val);
+		if (ret)
+			goto out;
+
 		ret = kexec_purgatory_get_set_symbol(image, "opal_base", &val,
 						     sizeof(val), false);
 		if (ret)
 			goto out;
 
-		of_property_read_u64(dn, "opal-entry-address", &val);
+		ret = of_property_read_u64(dn, "opal-entry-address", &val);
+		if (ret)
+			goto out;
 		ret = kexec_purgatory_get_set_symbol(image, "opal_entry", &val,
 						     sizeof(val), false);
 	}
-- 
2.43.0



