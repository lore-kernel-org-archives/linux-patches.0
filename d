Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11621D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793415; cv=none; b=cs5lRJvCZeQ3PrDdSV4PQSb6nF2oq2zHMcUAuAE/TdCTi4AVzzGhXPKnQ7ocAHircpojKA9NrCDoVmxDpjyqhIegvHtUKcoZ9epY5yeLRcxyToD53I7bf7uQjWjSoHTlpFdlTq3MmH30vE+P8jtV9RX+3Vmltq4GNx8Cj+Wkq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793415; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGX+pubTmlbICPCdev8JmD1OcIJLrEcIuRsQESJPLcYbQB77F8M32Hb3z1s7bHS8HnMt3wYhxW5r8xhoTUhEgQViqMZDF8/87RJP8/mSYWEXPbOd0h0RhWs70QPL3tNBmwCpE3hjsn94Xity3Ra+px+YssPVkTDazjC7fqc3Zpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QADog7oY; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QADog7oY"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb470a8b27so21099551fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793412; x=1730398212; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=QADog7oYBvz+gHx781vck9XbfkR3IWN8ykUur+T23HRRSv+VuV1Yc3DRmVXMb7hWcd
         /KwmFSDdddR8Zi3ekJwV9SFb/NQSpnonz+DIDdUlJ+WaZme77FdZOffw7yZ9KCxAWhDX
         x8RmZ1vrQRawK8GMtAWsRNB2PJJlRI0IX+OLPcX11lNDzn2orkxG3U/Gif5sYMi2EFfO
         rD6bdhkSQkkdmakkYGceQ7wPY5tP69U8/OfhMcq0V5g5eedWs0Gwtx5FXw4NnvnnSI+X
         8UvqH+ACa/OFdZ88tJ/BqEzVmVH4Q1BoBOX8kuXYFal7qVkaxDuPem23yzUfDlVJ45hn
         QFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793412; x=1730398212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FDLF+wZ8fUiMSorWVCzil1IX+MwisgM0ngRwnwlhGx9QZYFph1RpBIvfyIwRkJ91Sk
         FgB5FmoXtePrE+qK56i535z5+5Q3vCOCqBg4KZvZuqueGvuK+9HdTIUvpSbM8Q51dnJU
         Brp5KNOHuwIP6B5eF1FVfv6jBXmlEqakg8tgeFHQp//f2+NSmOgyHfzb+WEBSIvPZ6e3
         vwJvOAKPnxk25Y8jHk1L7cgRI7jki43luk0719GunJ2Q0wmez4iI3NpGkKSueifSlqbi
         COao7lRf4bY30Wwy+jLIxi5kwuRIwGS/YKIz0o/GxmOoBiUre6G64EEHV5UAap50Mc38
         XunQ==
X-Gm-Message-State: AOJu0Ywy240ruivQCSXp452z0gkkB4iAXl6WbQt/1bxn2N5qVdFaCnLC
	zOyo7RjzXPVmMmZkaXLXinHl6hIusAkiz4W0c6qqTbcwxprzYFKw51flizRW
X-Google-Smtp-Source: AGHT+IHl2VPLd4SaHqL/NRRfjBf8JIR/jUcwAB4Qirehpx5x9TEWmqxcPNUdMf3CvjdVo/qanTSG8g==
X-Received: by 2002:a05:6512:3d09:b0:539:93e8:7ed8 with SMTP id 2adb3069b0e04-53b2370d752mr1039047e87.15.1729793411728;
        Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243148fsm1450872e87.200.2024.10.24.11.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6790-1-vladimirputin693389@gmail.com>
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
