Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0602A23A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB25C433D6;
	Fri, 28 Oct 2022 12:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958741;
	bh=x53v19dcwm8p53E1FN3rTvzaoTzBosN5oupcM+jqhVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEqfNxTBqiBCq6ylLf8H+w7TuhCxv0HpPnyP2rFI5f1hgXSFkM5PVbnBdV20Wi34w
	 tS5kJleYRST4As86fL6QZJOB7/5CYuPxGyk/r9HmS5CDO3irSm5kYjeeNMZwXcWSlm
	 FbOUfnlCl9pIu+QZRYbYN2keWUHHnOb9dV4ehQY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fabien.parent@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.10 10/73] cpufreq: qcom: fix memory leak in error path
Date: Fri, 28 Oct 2022 14:03:07 +0200
Message-Id: <20221028120232.787502635@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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
@@ -215,6 +215,7 @@ static int qcom_cpufreq_krait_name_versi
 	int speed = 0, pvs = 0, pvs_ver = 0;
 	u8 *speedbin;
 	size_t len;
+	int ret = 0;
 
 	speedbin = nvmem_cell_read(speedbin_nvmem, &len);
 
@@ -232,7 +233,8 @@ static int qcom_cpufreq_krait_name_versi
 		break;
 	default:
 		dev_err(cpu_dev, "Unable to read nvmem data. Defaulting to 0!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto len_error;
 	}
 
 	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
@@ -240,8 +242,9 @@ static int qcom_cpufreq_krait_name_versi
 
 	drv->versions = (1 << speed);
 
+len_error:
 	kfree(speedbin);
-	return 0;
+	return ret;
 }
 
 static const struct qcom_cpufreq_match_data match_data_kryo = {


