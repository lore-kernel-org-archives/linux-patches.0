Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738428486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC20C433C1;
	Thu, 27 Oct 2022 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889867;
	bh=4kHUZF+AjruafifTCU4XMIzd0AbmpcJJB3gItGOU/5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWXLVWlzVwYUyzwuRZjXDeE8orbSiEYXunxJD1dNhAWlzzzrmZs+2Rm3WLrJ5jyIk
	 6Q/n7ySS3Q8b0l15Nw/kPZeXIodYJuWmN6VrflPX8vuIGF5VUnE6fJOwQglJkcMr3B
	 yGWcgwTGr/b5wg7X1CgFokxtDsuuIwz1ed4t1Xf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fabien.parent@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.0 14/94] cpufreq: qcom: fix memory leak in error path
Date: Thu, 27 Oct 2022 18:54:16 +0200
Message-Id: <20221027165057.675123658@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabien Parent <fabien.parent@linaro.org>

commit 9f42cf54403a42cb092636804d2628d8ecf71e75 upstream.

If for some reason the speedbin length is incorrect, then there is a
memory leak in the error path because we never free the speedbin buffer.
This commit fixes the error path to always free the speedbin buffer.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Fabien Parent <fabien.parent@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -213,6 +213,7 @@ static int qcom_cpufreq_krait_name_versi
 	int speed = 0, pvs = 0, pvs_ver = 0;
 	u8 *speedbin;
 	size_t len;
+	int ret = 0;
 
 	speedbin = nvmem_cell_read(speedbin_nvmem, &len);
 
@@ -230,7 +231,8 @@ static int qcom_cpufreq_krait_name_versi
 		break;
 	default:
 		dev_err(cpu_dev, "Unable to read nvmem data. Defaulting to 0!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto len_error;
 	}
 
 	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
@@ -238,8 +240,9 @@ static int qcom_cpufreq_krait_name_versi
 
 	drv->versions = (1 << speed);
 
+len_error:
 	kfree(speedbin);
-	return 0;
+	return ret;
 }
 
 static const struct qcom_cpufreq_match_data match_data_kryo = {


