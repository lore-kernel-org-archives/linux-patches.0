Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC42192EC;
	Mon, 23 Jun 2025 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717514; cv=none; b=gaIGe/gFlnojnIxKg4auyYjQoYEPI196vKoqF3YjE2WzyXd3ciAQi3HuQ4brB7NfxDhIFIiE0qVylwWXv5XngTFcEuFAVF1Z9nL2zoN67Rzn3MAWICzZ8qujZnkPePtfg7wnFWP5JynClWOP5G2evoBd5uW7Cfr51b5Lg6x0YZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717514; c=relaxed/simple;
	bh=Or2lhJOd2GanAwly+UM7GxxhACDPhj4lJWbOsKa1Q7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNrTgFgreq5Zm3YUrHIRtp4h+92PTXxATBj+penMHJFRl1sSL0vqcW41SgRXMpawI/STJSSN8E1hrNkwFjFA9H3ZL7bRZCw/r8PXGPpgHrTO4Hk1U4Lvu8390RcoDWK0Fy9tKTydN2OkUpml2+joRiRn5V7Wil7tn0Lsho3o/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrwbBU+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrwbBU+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A955C4CEEA;
	Mon, 23 Jun 2025 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717513;
	bh=Or2lhJOd2GanAwly+UM7GxxhACDPhj4lJWbOsKa1Q7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrwbBU+n2UAfGqd/fL8VAc2VVuVwyfjuJQ7COdMX6XA34cMueuLqDhPJGLzQLycrc
	 dLxkjRBVTmrPQGQjdc0IobkySYm678cvBcmfXqa2ZP+KxvG/zj2jfCaQ+/EzZeU2dt
	 4/OFGwG3lKl6+8Q232Gi9menrgUa50RzYc5/oP9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 444/508] platform/loongarch: laptop: Unregister generic_sub_drivers on exit
Date: Mon, 23 Jun 2025 15:08:09 +0200
Message-ID: <20250623130656.085776152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

commit f78fb2576f22b0ba5297412a9aa7691920666c41 upstream.

Without correct unregisteration, ACPI notify handlers and the platform
drivers installed by generic_subdriver_init() will become dangling
references after removing the loongson_laptop module, triggering various
kernel faults when a hotkey is sent or at kernel shutdown.

Cc: stable@vger.kernel.org
Fixes: 6246ed09111f ("LoongArch: Add ACPI-based generic laptop driver")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -611,11 +611,17 @@ static int __init generic_acpi_laptop_in
 
 static void __exit generic_acpi_laptop_exit(void)
 {
+	int i;
+
 	if (generic_inputdev) {
-		if (input_device_registered)
-			input_unregister_device(generic_inputdev);
-		else
+		if (!input_device_registered) {
 			input_free_device(generic_inputdev);
+		} else {
+			input_unregister_device(generic_inputdev);
+
+			for (i = 0; i < ARRAY_SIZE(generic_sub_drivers); i++)
+				generic_subdriver_exit(&generic_sub_drivers[i]);
+		}
 	}
 }
 


