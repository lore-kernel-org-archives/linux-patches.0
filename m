Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB71BD9D3;
	Thu, 30 Jan 2025 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247333; cv=none; b=iiFOYS+CkTJ5sNjPJVyuz+mEOpMl1G5rNd1fjTGRhC/JEQ50d/EM7/hbP0gGBRJk1Ij5ixNoSQj63iKTjwXcwBuC0JHCjrvxfjJBS6F8FeQFtybUbOBrf+6/sxPA7BQKZeo1RtuLTV35tjp97Sqqosa1H41kZCbLdZrQCIgmuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247333; c=relaxed/simple;
	bh=KFeAlNCCa9uwtbCnxOfli1gDDcJVOfZw+wuRl/UH68M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSZURHPTU902+H4boubR53ffkYx2lU/9LhjFaveCizv08PA9DiW7a36MlPmtMgV9ok/o1pz6SSHvrz0IKDkKQqw/jwOLx/cQ6ePkfuB4NSvFkC3EVTR0dWbpEqtKTqDZhb7DJTelgmx4eEFruzXGcGny4pk7rDu9O48xFuaVOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0olxTrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0olxTrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD13C4CED2;
	Thu, 30 Jan 2025 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247332;
	bh=KFeAlNCCa9uwtbCnxOfli1gDDcJVOfZw+wuRl/UH68M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0olxTrjCHWhudDm0L9l2ZjNyz4LYqNIt42Fpc7TpAu4NY7OsilTrIDl6v5+BJ+I8
	 UhvyPD945wSSMK9ioj4aAUuRkPD34YN4RB9jL6zexRBxqVl2Ya4xLwgDOAW/BJREGc
	 Iqi+9v/rJDgZkkWPggvajQRIH75qtJ6Slh0C8usw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@gmail.com>,
	Guenter Roeck <groeck@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Laura Nao <laura.nao@collabora.com>
Subject: [PATCH 5.15 15/24] platform/chrome: cros_ec_typec: Check for EC driver
Date: Thu, 30 Jan 2025 15:02:07 +0100
Message-ID: <20250130140127.903847480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akihiko Odaki <akihiko.odaki@gmail.com>

commit 7464ff8bf2d762251b9537863db0e1caf9b0e402 upstream.

The EC driver may not be initialized when cros_typec_probe is called,
particulary when CONFIG_CROS_EC_CHARDEV=m.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20220404041101.6276-1-akihiko.odaki@gmail.com
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Laura Nao <laura.nao@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1123,6 +1123,9 @@ static int cros_typec_probe(struct platf
 	}
 
 	ec_dev = dev_get_drvdata(&typec->ec->ec->dev);
+	if (!ec_dev)
+		return -EPROBE_DEFER;
+
 	typec->typec_cmd_supported = !!cros_ec_check_features(ec_dev, EC_FEATURE_TYPEC_CMD);
 	typec->needs_mux_ack = !!cros_ec_check_features(ec_dev,
 							EC_FEATURE_TYPEC_MUX_REQUIRE_AP_ACK);


