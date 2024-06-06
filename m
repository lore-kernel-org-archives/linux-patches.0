Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E97F198E86;
	Thu,  6 Jun 2024 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683090; cv=none; b=TFWqLRWkTOT3lD/2Zh32yl/fcUOUanRY+gXi/iMnieCPLGDJuPGG9oD/JwDiXFLlBnYEBd0LyHWxjja8iFYjZqyUlLU+LVJFy2USRBj9TGRds2qPLQG1SosEC13DifK/QEL7V/iX/8G0DfuLr6HJ47eSw8DHDOlhq1lt+qQGZkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683090; c=relaxed/simple;
	bh=FwmJSfd+KKj2jHumXHMwAkHPeRkr9T81I1TK1oulhgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pL/NdJn44mTruS4+z8if7ehMi2Q5yy1xGXZ9zIg0ATGBJQN513I5571Ig0EcOo15z9OrYqvDlRMVC1vm9mdxyrr5zrtuvhKBfbfWzcKwSzrfVEw8uo51PghvZ0iBhNEjZwKkUSb2mm2Fu2lib9BKaVJdTayQC0azoJsl2VPPhR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHEPfQgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHEPfQgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B853C2BD10;
	Thu,  6 Jun 2024 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683090;
	bh=FwmJSfd+KKj2jHumXHMwAkHPeRkr9T81I1TK1oulhgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHEPfQgCOwuM7Ej4pf7UNBZ5YjzNi9GFVs+CpPOKjg1zBiDzKPWpAtuAy+GW0EV+r
	 ZfCc/GF11VmtGmH5BCV/uM2ikD0B30r6Deqgsqv5t9/qoSQ38hXNPaiqCOuoQSaxe0
	 muvEiM8SKVT8rAUHzsRbEt8w5uctckluGarhtwKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.9 373/374] platform/x86/intel/tpmi: Handle error from tpmi_process_info()
Date: Thu,  6 Jun 2024 16:05:52 +0200
Message-ID: <20240606131704.385726123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 2920141fc149f71bad22361946417bc43783ed7f upstream.

When tpmi_process_info() returns error, fail to load the driver.
This can happen if call to ioremap() returns error.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org # v6.3+
Link: https://lore.kernel.org/r/20240423204619.3946901-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/tpmi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel/tpmi.c
+++ b/drivers/platform/x86/intel/tpmi.c
@@ -763,8 +763,11 @@ static int intel_vsec_tpmi_init(struct a
 		 * when actual device nodes created outside this
 		 * loop via tpmi_create_devices().
 		 */
-		if (pfs->pfs_header.tpmi_id == TPMI_INFO_ID)
-			tpmi_process_info(tpmi_info, pfs);
+		if (pfs->pfs_header.tpmi_id == TPMI_INFO_ID) {
+			ret = tpmi_process_info(tpmi_info, pfs);
+			if (ret)
+				return ret;
+		}
 
 		if (pfs->pfs_header.tpmi_id == TPMI_CONTROL_ID)
 			tpmi_set_control_base(auxdev, tpmi_info, pfs);


