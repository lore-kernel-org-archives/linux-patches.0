Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A926BFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13309C433D2;
	Mon, 15 May 2023 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170507;
	bh=JEIw3/JeNfM0mUIqTOhzCXaqqyzceP9zscvyxHK/3V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKPFKxBvc4CvXFI4xSV6pKihPi38Ku3tE6f0U8Td/ZSQFEuXO4gsQsahSDVDY09Pg
	 ccZyeAA1wvtft5rSbCa6+FVJ0nTMhR3G5UMVm7CSqzHHbNT/Ftmgifywsw3msL1isK
	 2EE2DuDUJDWZp9t5JqkEzE8LkPyWeitg6vImxwIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Wendy Wang <wendy.wang@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 123/239] platform/x86/intel-uncore-freq: Return error on write frequency
Date: Mon, 15 May 2023 18:26:26 +0200
Message-Id: <20230515161725.393612102@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 75e406b540c3eca67625d97bbefd4e3787eafbfe upstream.

Currently when the uncore_write() returns error, it is silently
ignored. Return error to user space when uncore_write() fails.

Fixes: 49a474c7ba51 ("platform/x86: Add support for Uncore frequency control")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Wendy Wang <wendy.wang@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230418153230.679094-1-srinivas.pandruvada@linux.intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
@@ -44,14 +44,18 @@ static ssize_t store_min_max_freq_khz(st
 				      int min_max)
 {
 	unsigned int input;
+	int ret;
 
 	if (kstrtouint(buf, 10, &input))
 		return -EINVAL;
 
 	mutex_lock(&uncore_lock);
-	uncore_write(data, input, min_max);
+	ret = uncore_write(data, input, min_max);
 	mutex_unlock(&uncore_lock);
 
+	if (ret)
+		return ret;
+
 	return count;
 }
 


