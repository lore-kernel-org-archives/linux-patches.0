Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ADD1D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793395; cv=none; b=lDpF80VoBb7vdPBABLLSj28ZlW4KcXfJRl74ivBlsYeR8z46q7CG/bg42++Swl8I5K2fybOcYKXK2gxBKhBfdmOCTRK4TZuK43JYxIJLaM0W/D0lm/kYyxmXnwAWy6VwtRunM/0cM83ZZWTU/CErS2Ft0PrFnk7KZhr89ru9VkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793395; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khf0lmC6uuaUzy3E/K2LiBM+4kic2omicXSgspibL/kaKbuQAUJKXKGCIsbSNQnVreDdFS5x6iedVgKTaigQ8uEf91MWju0bNNgl/CZGoRhtNRHtLghS3RbMjZCFWbY4LOjmzkSp8k8djIsa+qQN9Me9jad/OgWPoTlmq4B3DEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8OegppZ; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8OegppZ"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb49510250so13750761fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793392; x=1730398192; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=a8OegppZbsjK7caLx7STEeI+0x+ualvhTzErE4jDOvw90uKO99m1f4QXds4aqOmoUV
         vH+p2YaRvBnhqlanK1fkX7Gbn42TDTUQx2PKT1PJSY8MCGoDT8cVIt1VfU/ZT7NbdLg5
         QBsrr7RehN2yHkTW4in7v5Tx01Pu5NWOfN6JHzHxd9elDQhqsLzRkO0v3n++JpV/wyHo
         Iv0Kp6N99+M/zh6hCaSX4gj2lMJhRJgymgdjPnu1H27oqR6CLtYdFi4GLluATcpzHijZ
         yFYdfAimAoDuKrER1jaNZ/ObNDhI+qzQFPyHnf/C72c6FBqif5S/Oc6wBv8SDOj2VAf7
         d9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793392; x=1730398192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=xPmqGrRZhDVSO0Rk4gPizWxubERb5dUu7MV1awyMwEbJJElhwj0IuegSGZN5D5zv3+
         NHaHZETHtM+fxV/o/+Yl9lX2gcCBdm1BeyT4PQx5fmbO97daNTvLz3V5yJH1h5UHYB4X
         Hoq+T+062Y1A4eqUtCbgu/DY+YtBSpk3yG3H8x+lLN8R3i2B1gvyiFiRWR4FuSleThFu
         arn5qkmw2SP5HXamOnBV3cd75ZIklQu8b5ngg/DT0layBgPiQY8gNmQ0hsxlIckw32YB
         fCcmigtlRZVzSlNsOtkCzbCSAKZ+894uyyR9Kwpiw465kImUFwHk+EUfqmcnELGyNyIz
         QhEQ==
X-Gm-Message-State: AOJu0Ywehl+tTb1esqOr9NblUJ3KGi0HvXCvJjbZs6cmDAMFwir/C0ti
	up3UUQLN3J4xwLD/6RCULxYT1q9ff9hlSdnRsbRiA7LVgnAIBcD/
X-Google-Smtp-Source: AGHT+IFmzY8Zhy7B+Zo1SLyYjHEdCGAg4U0UKT9mP/cUauOzSx9Y+oVlw39XbnJ+8MlavpTP4MqlRA==
X-Received: by 2002:a2e:be88:0:b0:2f7:a5fe:adbe with SMTP id 38308e7fff4ca-2fc9d358cf9mr42861101fa.18.1729793391872;
        Thu, 24 Oct 2024 11:09:51 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf7b94sm14973861fa.98.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3555-1-vladimirputin693389@gmail.com>
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
