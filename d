Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F751C0DFD;
	Thu, 24 Oct 2024 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763846; cv=none; b=cXFgvkfoZaWOyCOtIsFq3JVnp7FG89kn9enp4IodZLIySNxyZJDvZ39r9h1h86OZn93Xri8X04NCfbhciURMa8Nd8Gk3qoverMjZlTfnSfx0EyrW5mwtPvQoOrVNZ/26XiPFmU36/WbF7YiORS3ULl5KEbiaBI9tt8brDndRQhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763846; c=relaxed/simple;
	bh=PVT4x+5HpkJQPwdJsjK0MwsWAxzsoTXRtb4fDO7mWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOAtxiazhUUH/3Dy2nRkZL+lQ/+ha/CKEe44PyksJRpGI6be3jbG1teBSZcOzS4hMiwYLUvoJVfTg2dDhC0BHGFBP+4ZLXHKkglewEZGqRRZmCcu8GB/7XWV/ieW/uHofxbA7oj1CtDUAycsu7s/1GVVveNYNnzlft3SqSL+cXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVrnlyzs; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVrnlyzs"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f84907caso780723e87.3;
        Thu, 24 Oct 2024 02:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729763842; x=1730368642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVT4x+5HpkJQPwdJsjK0MwsWAxzsoTXRtb4fDO7mWLM=;
        b=nVrnlyzsfeVKgoypgV2pPLqrCClWmyzQM3bqxqTdqforhrLbUfhaxLJju5Q1Dk1Qyu
         M8KgFjsOtaT5SR9eRNlKQyci3s8oTQLxfezWY+a3vE7bT7+0oWp2wKbsH6RSI9EbBPui
         WbGURzn1bOAQ/E7XhcYhnrh984FXOWQQxsYN5rghCXRRLijW/Tu908Q8eW758UGKoSFS
         Oc6l7m39hHd0o3SCBrt/hlToNrQgmJ+Mdk9R3Ucta9bS+JO3mFzqpzQAyVDvVLSFzw2J
         7JE3yKhoSKkOZe6m6ZOzSOlDbdcbHqhM6geBxIec+eVdf+JMQbWo9WtgwVJ0EBrVansh
         p6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729763842; x=1730368642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVT4x+5HpkJQPwdJsjK0MwsWAxzsoTXRtb4fDO7mWLM=;
        b=C54XSSbmhGFLKfW9QB6pjwqG9lCobC4b1jDmncPuXSNMZvL/kh2pwnDPiArw/LN1NK
         QYcmQGI3uDgN8EKYTnzJXYagUKMWM4JiZ7VKP8CY7x4OBYFwlOTa81ggIKhLwzgeH6Ws
         TUbxqZ4gGaW/KwGAliEWxPnyPH+pBdmECq7RA8Z3mRwUEX4LmwRacaK7u8HfOCnrxDbO
         H8c/bTd91yrDzXFaldFHS6oz1pKgw71ONDIhbmS1gcUgukILZn3eHi5DJSK9HLDsY24b
         7KK8PmJ5+Og7P3AFeN/SrmTP8j04+EQzXDIshNQPdl3zrcjsQphGHLgVj8RzV76kelGh
         57Qw==
X-Forwarded-Encrypted: i=1; AJvYcCUXxjKy4qgCD5fkhFZJDMg35SQaJKSxJ2nB1KzxO7hKhwCdhuTqDkYyLJ4xWTVg+pKx5sTXahnSRg==@lists.linux.dev, AJvYcCVNmkiaG0MqbGxzmwkTo5hASMeiVW6cnHMSWaucVGbmNofh8JGp93EgWup0Pd1fQi0mQxc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT8Qy7Ayvl7bzPu2b4XYZ9Ez1tp1j097ufg5M4Zju/CmVKNmYk
	B5ECE2QVCI/PARmb0M6i+s2BdQWZ0BObX9bulZE6jrc6CbdBV6i+
X-Google-Smtp-Source: AGHT+IEoo2Czcs+RGUiJMg6LdY8jxuXv0lNt1Zx6z+DI1lmpOeNWP3pCK2fVmcYSte0wULTaokncdw==
X-Received: by 2002:a05:6512:a90:b0:539:e97c:cb10 with SMTP id 2adb3069b0e04-53b23e857f8mr904316e87.40.1729763841812;
        Thu, 24 Oct 2024 02:57:21 -0700 (PDT)
Received: from seven-swords.. ([2a03:d000:2:9006:4eed:fbff:fe72:e806])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5988sm1310862e87.2.2024.10.24.02.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 02:57:19 -0700 (PDT)
From: Ivan Epifanov <isage.dna@gmail.com>
To: torvalds@linux-foundation.org
Cc: aospan@netup.ru,
	conor.dooley@microchip.com,
	ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org,
	dushistov@mail.ru,
	fancer.lancer@gmail.com,
	geert@linux-m68k.org,
	gregkh@linuxfoundation.org,
	hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru,
	jeffbai@aosc.io,
	kexybiscuit@aosc.io,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com,
	netdev@vger.kernel.org,
	nikita@trvn.ru,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	richard.henderson@linaro.org,
	s.shtylyov@omp.ru,
	serjk@netup.ru,
	shc_work@mail.ru,
	torvic9@mailbox.org,
	tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru,
	wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com,
	xeb@mail.ru
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various compliance requirements."
Date: Thu, 24 Oct 2024 12:57:08 +0300
Message-ID: <20241024095708.189649-1-isage.dna@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
References: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


> I'm Finnish. Did you think I'd be *supporting* Russian
> aggression? Apparently it's not just lack of real news, it's lack of
> history knowledge too.

As an avid history lover, you've seem to forgot, that Finland fought on Nazi side.
So yeah, we're well aware you don't like Russians, unless they're in concentration camps.
Which is exactly what you do now: segragate, based on nationality. Strip of credits and names.
Once a nazi - always a nazi. So, fuck you.

