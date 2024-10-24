Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF632003A6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793388; cv=none; b=XN7oSeBaI2ydu7o5lFTrhCRUd3WIONtND1IZsjag7RiHBCTw4Ing7rGeazKOmU4lg+ZyHaWQEe26HPLA51rTU6VZAR/tJODRRiHA2e9Gd1rc9HpoGdx+uiCF6UGGCpMLhJiULFBOEWPO+dCPmXiRGaZISa+nn4fc8Cl5locmmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793388; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ublbgjqYDvoesHcWo+GkJVk8V7oPelA2puZCyYib2lNIAEfVh5G3tjuG7LecrkMcvAvNlSbtaBWmJByycLq5uoqlAXIUNdLTIojsG6E6VbnQ4g8mImcXFyKo6LEJzW+PelsljwqQ8nIlS3zOLkREZGSl/k5GawRxTBw+Xr7Iv4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gjsIRir9; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjsIRir9"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb50e84ec7so10977901fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793384; x=1730398184; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=gjsIRir9hY9V54Df4RU1CgPImvenyx0jnNd9B8FbFvJA5iPFmCAWcHGpkErCVXGRDi
         SfTlg2vWtvvo9DJF/ZwFy58EuG0PupBBjfDN+1kyCjCcVPkhhR39YewT78RVWutXZOL7
         4LJThzPs6q3shJm3IOQLBQLMy8F5ihKS1Ac4qg+1NbNMB/fcWiXxQxH3E9v/8X+5pyLD
         SR1mlSGtRFJGL+WhVSfT/ZOH0qj51l3ecC3SSTsIW9JFW9srRUf81Y8U+3EVpHBatM5O
         39NnEAKEG5+RoQwaKOHqPPtekN+qSRQHLhgzvoOKX6pRabB6+BmQgECMh8pYsVw8+VE6
         0C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793384; x=1730398184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=GgBu3s9rtPXKveX9qyMivgXVzA1GjJorAPlsIeB3ND9325lgCX8t+Ym6/XvWfp3XxL
         RyNRKcByy14FInEpoa1BV8TAGa6zT6nzv7imf2ap6tHQ6pmSvQwdUB7yD9S3/De3Pm+Y
         1j59ptUfed1uXaEgN2WnF0xEia/r10xNMUrcYbave3U5tITBwSnbb25hfLUpGcLhJ7Zc
         VPj/lOb/dfLEUIvxexDO8eC+/EjtghzoUrQEHHKVfoKKbmeEm9JA5WynsRs+6T+P1jJc
         ZdKq0RX0CG0SsxHAAWxjh0oGASjbUP8Ig7sLfx0Cc80D/Oc2z8/Rts81FRR381rBLC0l
         un/g==
X-Gm-Message-State: AOJu0Yw5dekoOFs4ha8AOuJd/flQ9FLcrt7YQj8vkAfxbGh5XqXR10Ui
	2jwpYk0rVtSSoPBWnI2cKuociINtoC3ruA/8leisLPpmN7rDKDXXy+bZCR8q
X-Google-Smtp-Source: AGHT+IET1MNup4KBgjzKYdKoWfX1b6UT1qaK6KaHyVO3p8Fnjo9dZAI3LidJ43o34XT7eLpDLWAn0w==
X-Received: by 2002:a2e:743:0:b0:2fb:57d6:f464 with SMTP id 38308e7fff4ca-2fca820b2a2mr14795901fa.20.1729793384411;
        Thu, 24 Oct 2024 11:09:44 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad60dd1sm14754541fa.40.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3262-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
