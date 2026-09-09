Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF81B56329B;
	Wed,  9 Sep 2026 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962394; cv=none; b=AquYnmFngYWNNiOSwWpwTo+j3evYvrmPXNXEVJfgYDZw+kDSCv/d6FhRP11JoiYw8CTsYr7HBIp8y4JvKIO1ikxzf+2WgZKP0floWb3wB1wjUcgtQIxjWq0/B0TJBsp+J5Ahs3VZoHxtZSlPa0jXE1/KROVnCJ9fwV+dhEXprxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962394; c=relaxed/simple;
	bh=ND+z72PtXF1ZELaWeZYxEpwPyucmp2lktZUya7TXNgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/i539IjamKVnqmIpvUexMPMYBnre7t7zNdLGd7Ga200OWiNQX+nW+BDa9OAQE8CwkXSsG2KDq6dy3xnLI8tL0IFRVb7acLlrLVMW9FDGuNdABH40qwutN+xQ5zeK2C+VSxZDVqs1nI4TPcpEphsOtNmRo+cX+7AN7XVtrk09dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjQGNb5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjQGNb5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550871F00A3A;
	Wed,  9 Sep 2026 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962392;
	bh=jrcLBszXFY9N2BrypXCjsgnGC/GHjNRC8oAjBHN3sLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjQGNb5+YlidYnCZog0SWYxNcfPkxdqyPfkLQ5V057KgCljT3CPcvbojPm+Zb4lip
	 qZe7OcK38ZlN8KeZZUZRpGcLhXHAew71muVUhYg+Hj2G4dajfytTLPWFfL8vSSh4J8
	 Mddfk5NEMeFXGDGKwf9SKSzSORIDFD8fsh7T1coA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 275/556] iio: imu: st_lsm6dsx: Update enable mask when using sensor fusion
Date: Wed,  9 Sep 2026 15:39:15 +0200
Message-ID: <20260909134240.296469921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Francesco Lavra <flavra@baylibre.com>

commit 4a56c646e1bd4f22a2dcd65ef3723af957c651a9 upstream.

The enable_mask struct member keeps track of which sensors are enabled in
the IMU. When enabling and disabling the sensor fusion functionality, the
driver does not properly update this struct member. This prevents a correct
calculation of the number of samples that should be read from the hardware
FIFO; as a result, reads from the FIFO can be unnecessarily split into
multiple transactions, some of which can read past the FIFO length.

Fixes: cd4e1141bff8 ("iio: imu: st_lsm6dsx: Add support for rotation sensor")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_fusion.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_fusion.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_fusion.c
@@ -112,6 +112,11 @@ int st_lsm6dsx_fusion_set_enable(struct
 		return err;
 	}
 
+	if (enable)
+		hw->enable_mask |= BIT(ST_LSM6DSX_ID_FUSION);
+	else
+		hw->enable_mask &= ~BIT(ST_LSM6DSX_ID_FUSION);
+
 	return st_lsm6dsx_fusion_page_disable(hw);
 }
 


