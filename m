Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC192274B46;
	Sat, 12 Sep 2026 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237630; cv=none; b=LH4haSf2ty0V8/zDdLcz9I5ehH5AXkR+p/H7KhVyhNpnmsbIcgG8vUhpBypeLUGqOirBvaeFOgAwVbq0puxLYAarBJX2RXMSnfohF5xOZ6lZN4Gp49UuaKIIXfj0Ald64UC6NFajjylaxG4wyNlxlKqT61i9PFCIjVoevQaO/Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237630; c=relaxed/simple;
	bh=rur39Q2qF0d86dF4ZQwKzxcFVDg5IcS6WIidWsJQUHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ2nD0IOM5qpNi0hckX0dIeEjpDnsL/2BUwxqiCARRae0sqh8Pv8I8zQ9sLIqNqhkDvS0n4JM1PPZKW7InVu/dCRyqRkmJhGckmnte8Qdq0Hgt0VrSdnFsWE3WW2JgS6v9wv2+3F8kIDvj4Hygjh0SxNkmseNo8qKO6P00ri82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGiG76nN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGiG76nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3081F000FF;
	Sat, 12 Sep 2026 18:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237628;
	bh=5wiWJUwbiq0cHQ3Pe6jIKK4pAiZuLe8eZ9kswTj2tg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGiG76nNTHwANBQdSRzkP0Kee3SlUzrWWBaYRj3f6bMlZiHc4+DLrQTlkTPrR93Ht
	 +FqdNLn7mkcBjiMEVe4jKgoI824HuG986O5Ho6NEf3Gfb++Gxx8dJ3kR8sMxYGStQW
	 qEXxMZHc9gKfni+i7lBhNBzSWSIOQPfjghkol+QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 296/935] iio: light: gp2ap002: Disable regulators on resume failure
Date: Sat, 12 Sep 2026 08:55:26 +0200
Message-ID: <20260912065533.600374813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit a41000ba3a230bed1e422f283486ff8f77fe0d30 upstream.

If enabling VIO fails after VDD has been enabled, runtime resume
returns without disabling VDD. Likewise, if device reinitialization
fails, both supplies remain enabled. The runtime PM core keeps the
device suspended when its resume callback fails, so the supplies must
be restored to the suspended state.

Disable the supplies enabled by the callback before returning an error.

Fixes: 97d642e23037 ("iio: light: Add a driver for Sharp GP2AP002x00F")
Assisted-by: Codex:gpt-5
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap002.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -678,7 +678,7 @@ static int __maybe_unused gp2ap002_runti
 	ret = regulator_enable(gp2ap002->vio);
 	if (ret) {
 		dev_err(dev, "failed to enable VIO regulator in resume path\n");
-		return ret;
+		goto out_disable_vdd;
 	}
 
 	msleep(20);
@@ -686,13 +686,19 @@ static int __maybe_unused gp2ap002_runti
 	ret = gp2ap002_init(gp2ap002);
 	if (ret) {
 		dev_err(dev, "re-initialization failed\n");
-		return ret;
+		goto out_disable_vio;
 	}
 
 	/* Re-activate the IRQ */
 	enable_irq(gp2ap002->irq);
 
 	return 0;
+
+out_disable_vio:
+	regulator_disable(gp2ap002->vio);
+out_disable_vdd:
+	regulator_disable(gp2ap002->vdd);
+	return ret;
 }
 
 static const struct dev_pm_ops gp2ap002_dev_pm_ops = {


