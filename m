Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3D72D8DC4;
	Tue,  6 Jan 2026 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720808; cv=none; b=WOmx0moemK79g1YjCqGUXSFTtnYO+go+JWzfENsrbAS8+MTVRlXy0RL0S7SLbZi6qn/U5P1zUkIunGARVjwcn5DSDbhy0hke9OncZDtQUHCEsq/7S7nmrFIu2+/1OsOItkMoRm/KjzSkaBfU1TyjckVF+0jklj9wghzU8ROSKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720808; c=relaxed/simple;
	bh=OaU8aMK3Lfp1AURX9VLhp7zzzL5/UDbTm2delzXFlMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXGUkhrcj5ytDhouUq3CMof6p01lWLXpFWfk/K2kENqfEQlmuGNvuUOm9ihnYnX64GLLRy6GrxvbKuNDcioI70+QpbbN3aOBmEv3Ycc7FQBOARtxi5AVneHoKQE3PdelqnGnREyxG0ASds40McFfgqkEPG94Dfwtf+dApME1OJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kBIg1mT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kBIg1mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D47C116C6;
	Tue,  6 Jan 2026 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720808;
	bh=OaU8aMK3Lfp1AURX9VLhp7zzzL5/UDbTm2delzXFlMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kBIg1mTQDt5btqmNYHWcraHWVYavfl05RaI2sE/WKdSoQHYKc/l8e3Xz4xtWP3qj
	 0i8juXW/rIG2ylqtRtjVf/GyA/bM7OSxigcvTL49CknRbtLlCUsByJLA8CLmpEj8G1
	 SnoHFTOaSAsxQIzY2A0F90HSdiJE/T69CVpsGP1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	olivier moysan <olivier.moysan@st.com>,
	Wen Yang <yellowriver2010@hotmail.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 346/567] ASoC: stm32: sai: fix device leak on probe
Date: Tue,  6 Jan 2026 18:02:08 +0100
Message-ID: <20260106170504.125782272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit e26ff429eaf10c4ef1bc3dabd9bf27eb54b7e1f4 upstream.

Make sure to drop the reference taken when looking up the sync provider
device and its driver data during DAI probe on probe failures and on
unbind.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 7dd0d835582f ("ASoC: stm32: sai: simplify sync modes management")
Fixes: 1c3816a19487 ("ASoC: stm32: sai: add missing put_device()")
Cc: stable@vger.kernel.org	# 4.16: 1c3816a19487
Cc: olivier moysan <olivier.moysan@st.com>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: olivier moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20251124104908.15754-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/stm/stm32_sai.c
+++ b/sound/soc/stm/stm32_sai.c
@@ -127,6 +127,7 @@ static int stm32_sai_set_sync(struct stm
 	}
 
 	sai_provider = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!sai_provider) {
 		dev_err(&sai_client->pdev->dev,
 			"SAI sync provider data not found\n");
@@ -143,7 +144,6 @@ static int stm32_sai_set_sync(struct stm
 	ret = stm32_sai_sync_conf_provider(sai_provider, synco);
 
 error:
-	put_device(&pdev->dev);
 	of_node_put(np_provider);
 	return ret;
 }


