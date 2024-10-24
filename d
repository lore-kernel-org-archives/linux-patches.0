Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1CF155308
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793394; cv=none; b=ftV9fVz8GsQlc4KRPexuH7gjzp3jJiPbCbssdJ/Y8NkemOwV6MVRJ9Dr962TPEbjVHwmpnrk+qTnL5x2VFVey/B3ZMZJsd5dww8twwlbKDX2QHiHMwX/h1wXKkx4p3kCAFVnrgDvwuL3sIX72dZq/KJk0qnIH3PdWV9pl+MOSYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793394; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpOj0J4rIr/o+zJJGhS3iFN/ewvBehUDM9wXrVHvFMFtptJ4sKteCC+As84/RvLFkM1qF8KPQQg8y1MCi06RfLl/Ri5AFgMP5/rRxS/LQOlQKD8VtifYaL3eCijgMYZZYsPez4lTkLcJ4/gC6f+dhsSAIsvDzKsBVY3xd3bUGN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVZmSvxK; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVZmSvxK"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb5111747cso12768081fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793390; x=1730398190; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=BVZmSvxKH7XPu2i2PQz0lBm5Y+KSTAypRZHqBkJ/Y1isxuZdf41hzqz03v2Ay8yfbi
         +N/8o6M15H9OTLztWe89tZrXPW4yRgFpH8qxl7AbjcFZcvHBsSmTTZGmQbk1XrT/+sSy
         OqA42Mommh0YhmNls8aogJHkd3/F8+2/PE59XIol+jz3RgO5kuh7IUMHm/1EtFAp2e8j
         coBFERUC1bgi5WshXocd2S0e6azinFI10dPwWGRvECz+7Iga6UpJyM2xMF4eOPm7MDdU
         d/jeKald1bcXbWAjhIvwu66HwFfDvhllQDOvYQZZ5eWp44pBBrdE1dFfMqK0DEPjNDEe
         Bpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793390; x=1730398190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=eeniubRNjDTnIVGlmEWa5rUmDk/5Cu12r7/aodjJ3Om9M42RFiSrPXGFX2euCzTnB5
         U5b7dXMGDIhzMoRGYWA/+wdRAcsvUETRJsBhUn8uyv2Nf9QSxtY6Ri6IZMs+wFaeoST5
         cOnHIRyUuitXkovgaNI9W11jtP5vW2SCdc2JhnKF4NjXX8V+oaL2Uq1CqyCStmUfuUNq
         zfBBQT8vQIEeMumZtszm1epVG8FKPNllADimcMR198nBqZvyx4dVK4Eo+XPo97P4nEIC
         GvdJ0XjrqmN+8w7pHajjIli9Xi/+xIQUt1O7dZgrvl/acbU52+PNjM19h9VHWCHjTknl
         rvjg==
X-Gm-Message-State: AOJu0YwSqDb6wjiHtuQnK5FtWMbJgXKtIBDjggFGkgdTLdCNh6uNVutn
	/Kq1zRHwwLqir70dLOuCrKniI8b8LIACSQbMILGllgSHRMeIKXlJknXwDTks
X-Google-Smtp-Source: AGHT+IHsLMtsfI+rRq2MhK1NzchpFYd0M/OgRnMdGsQWcCJZpLX5Ipv2G7c03s0kWMKrVvfliOyIBw==
X-Received: by 2002:a2e:743:0:b0:2fb:c6e:9a36 with SMTP id 38308e7fff4ca-2fc9d37336dmr32204481fa.24.1729793390167;
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad4b697sm14437421fa.12.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3251-1-vladimirputin693389@gmail.com>
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
