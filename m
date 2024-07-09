Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4273C1581E4;
	Tue,  9 Jul 2024 11:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524255; cv=none; b=GlDbZTKkEF3QpeHpj4IhtLMlUsuZ5vgCvlBiLVQO0hfBgyAFR0LFgbYt0FnBNY//QkYkbaQYtNse0OLF7qQ1XB6VKFVThNp+pEavqICitmM5Yh0FcHDAw7izRInQkv0AKEpdNQsfio1OGzpf1ABjzGGIXZUR8JU6e7c25a1Vc1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524255; c=relaxed/simple;
	bh=t8cGxOOArMbe5H2kIYdUZZwYwbbndiNRHLrq3mc52PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQPMkAUaj8tzvKNJssMX/OM+3uZnNGGBrpqQdR6bpTxscJE0RVQT9/OnZlDnr+Tr5H87oAhMI78s/D9lAPxZVb1QoTtO9GTp3ir++uPqPIvbdtNhAr5egyMpqDRROpb/XOiIXgKg8gmJbl8IqQ0C1bAXCX6AmJm9y/Nq3NRM4T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPCBtAPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPCBtAPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C3CC4AF0C;
	Tue,  9 Jul 2024 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524254;
	bh=t8cGxOOArMbe5H2kIYdUZZwYwbbndiNRHLrq3mc52PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPCBtAPPl1XQcbsg1NZ7RRtOR5Sb8seHgVKNN+LZjVocoA8svHhrjuGaIAWFlQXQR
	 5LeD2YsvDCPluf6yY4jZrJI738FmuBQe1ajgBaNpaOu1Wo9FnvaIVC/YfefXq007WU
	 AqGQiIpWP3pCqy7hmuUnm6Y0x9P8cIMSaKrz8ZsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Petr Oros <poros@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.9 122/197] ice: use proper macro for testing bit
Date: Tue,  9 Jul 2024 13:09:36 +0200
Message-ID: <20240709110713.674762062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 7829ee78490ddb29993cc7893384a04b8cc7436c ]

Do not use _test_bit() macro for testing bit. The proper macro for this
is one without underline.

_test_bit() is what test_bit() was prior to const-optimization. It
directly calls arch_test_bit(), i.e. the arch-specific implementation
(or the generic one). It's strictly _internal_ and shouldn't be used
anywhere outside the actual test_bit() macro.

test_bit() is a wrapper which checks whether the bitmap and the bit
number are compile-time constants and if so, it calls the optimized
function which evaluates this call to a compile-time constant as well.
If either of them is not a compile-time constant, it just calls _test_bit().
test_bit() is the actual function to use anywhere in the kernel.

IOW, calling _test_bit() avoids potential compile-time optimizations.

The sensors is not a compile-time constant, thus most probably there
are no object code changes before and after the patch.
But anyway, we shouldn't call internal wrappers instead of
the actual API.

Fixes: 4da71a77fc3b ("ice: read internal temperature sensor")
Acked-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240702171459.2606611-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_hwmon.c b/drivers/net/ethernet/intel/ice/ice_hwmon.c
index e4c2c1bff6c08..b7aa6812510a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_hwmon.c
+++ b/drivers/net/ethernet/intel/ice/ice_hwmon.c
@@ -96,7 +96,7 @@ static bool ice_is_internal_reading_supported(struct ice_pf *pf)
 
 	unsigned long sensors = pf->hw.dev_caps.supported_sensors;
 
-	return _test_bit(ICE_SENSOR_SUPPORT_E810_INT_TEMP_BIT, &sensors);
+	return test_bit(ICE_SENSOR_SUPPORT_E810_INT_TEMP_BIT, &sensors);
 };
 
 void ice_hwmon_init(struct ice_pf *pf)
-- 
2.43.0



