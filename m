Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEAA332610;
	Sat, 12 Sep 2026 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213789; cv=none; b=kRCpD2IgRBnx3sdB7ApWtQ7sb/vWCP0w/Nma/UrW+mXqILBDcLtS0toO1Qdzodyhw540iUkKM6kLVzEJFXIexJJhHohgCEvNGW8gvVIQwMdH5JMkuKKu+Bocr0YNaS1AQquxqUoL0Kk8VSLYQX8tddkienAVQmwH6CG28w0VpB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213789; c=relaxed/simple;
	bh=m2vLjiOqMfZz3VGo+r/jH7ZzkSO+79s2sP8TdMG0jWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRlOV9waRWdBf89GHgalmcRch1jxAl3RWoI33hXUdhrf3z5yEAUP05ncr51kPmaF2G6Lax/8uk/mFSME6GJne/BmWhKIiCqZ/0ranlAre7YvuPR8TcN4A7fBUGr7PodqIRz4+uBjrFV/axTeyuNdSY31jQA4CytnfU5EYlwgnB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWAbocGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWAbocGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CB61F000FF;
	Sat, 12 Sep 2026 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213788;
	bh=eYFxkPz6vj+L1qAGKdg+nAV5ZwxxbgMTH7OH2nInXUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWAbocGlBY/6GEEAYLPJPfVSiNfUoIrYIn8nKNueuFq/t9aAq2fvTFrHQ5QvuhN/D
	 ntaot9ujQUSfwVhLg/XAmyzQEaMvMRQdnL+86R60t9KOIwah6gfAQuUbY1GqWMCtP1
	 9gMgL5qmjgjWGhL5Qe/SLGU4vkqBNdlNjMQcwy3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0194/1376] media: i2c: imx415: Return test pattern write errors
Date: Sat, 12 Sep 2026 08:43:40 +0200
Message-ID: <20260912065611.874183454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

commit 8cd5735b88d76dda80b089031747b6f18ee0bca2 upstream.

imx415_set_testpattern() accumulates failures from cci_write(), but drops
the value and always returns success. Return the accumulated error so V4L2
reports failures to userspace.

Fixes: d5df1c7f3f83 ("media: i2c: imx415: Convert to new CCI register access helpers")
Cc: stable@vger.kernel.org
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx415.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx415.c
+++ b/drivers/media/i2c/imx415.c
@@ -721,7 +721,7 @@ static int imx415_set_testpattern(struct
 		cci_write(sensor->regmap, IMX415_DIG_CLP_MODE, 0x01, &ret);
 		cci_write(sensor->regmap, IMX415_WRJ_OPEN, 0x01, &ret);
 	}
-	return 0;
+	return ret;
 }
 
 static int imx415_s_ctrl(struct v4l2_ctrl *ctrl)


