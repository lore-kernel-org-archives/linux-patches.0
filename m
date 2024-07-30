Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA218B466;
	Tue, 30 Jul 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359257; cv=none; b=KSevzCIPGA2hhBG1S7pEdMtVjUEg6GzKqkeHCpRgRZ7OyYYxQJ0iEcrxvPCEOTkmNTrL/rEiI5EyleDAOoGFCaB7fjLTNDbloa7JLFgOBdq2juej8697B2ZSw6/REY1xhYgXr1NwOMZfNJIivPMUHKmNk4zyX7Fzwi8Fob6O/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359257; c=relaxed/simple;
	bh=TC8pL4QeKezOgn0bfVfI/rBxo9je0F8UDeUtUle0EUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTDghKMGU2ASMTUPVT24E6bbQPOln9Aw+AnIaiew7Vj8lMIGoYKH4GviXkqk1pxrm094lhQ6UEvtozK4lqYH4B2SM88YQY9hx/YU7RVsAu8/+IT2HXbEuwB/wY6cB53zVpvJ3NR2fCqahjw+zSXjfxX8hwG9aaMqE/2UKLe6nqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+AOKMiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+AOKMiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C528C4AF11;
	Tue, 30 Jul 2024 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359256;
	bh=TC8pL4QeKezOgn0bfVfI/rBxo9je0F8UDeUtUle0EUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+AOKMiToxY+pyVvId/Ivz+Tw3gjWQkcOvNI6vCSNIKucY+jx3QxxJRIQ2K7SDHTl
	 eh8tTwMPaew22JejqUi3JR9b2L8qa+/7DaqDvk10Z+pmVjulCHN2xuz7jl7LA2NFpU
	 Q/RziifYAu8xCh9NofC6lI6JVttIrfwvuNcDHKc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 440/809] ASoC: amd: Adjust error handling in case of absent codec device
Date: Tue, 30 Jul 2024 17:45:16 +0200
Message-ID: <20240730151742.080360785@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 5080808c3339de2220c602ab7c7fa23dc6c1a5a3 ]

acpi_get_first_physical_node() can return NULL in several cases (no such
device, ACPI table error, reference count drop to 0, etc).
Existing check just emit error message, but doesn't perform return.
Then this NULL pointer is passed to devm_acpi_dev_add_driver_gpios()
where it is dereferenced.

Adjust this error handling by adding error code return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://patch.msgid.link/20240703191007.8524-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index e079b3218c6f4..3756b8bef17bc 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -203,8 +203,10 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 
 	codec_dev = acpi_get_first_physical_node(adev);
 	acpi_dev_put(adev);
-	if (!codec_dev)
+	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
+		return -ENODEV;
+	}
 
 	ret = devm_acpi_dev_add_driver_gpios(codec_dev, acpi_es8336_gpios);
 	if (ret)
-- 
2.43.0



