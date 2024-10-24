Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157681FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793421; cv=none; b=hCJSTdxBuGe/dXUcDjiYyR8K/2LjSDBlbDrMzb7Ec3tZQQlwiIFp3tBaPfahW7r1YhCTHYvF7d6oimlPd3bKUQqFzzOwQu2dA86BA4/mfUwyWQQ5lnbJamF5lN0lC42mQO8Nd/hb0VXJpe6Mz5hVqdjJgzrQt6hYvJFWw6QunzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793421; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lu7kk+UiEzZf2M98+9GqT70DbhsUMWAyqnb90fhICT2ZZ1HHfcZtH3twFG8n4HE9jb0rHWVuPUi5YPF8sRms99t2VsAx0Ox8FamDUoSfFsNPAdR7PjtSu+HJ16T85NJQ+xvgFxvzAO+q27QsWUpMZrMF//SDHhIABr3VhxSBLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tt38eTyv; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tt38eTyv"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-539eb97f26aso1277744e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793418; x=1730398218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Tt38eTyvniotfR+n6b9djpa/n/wFt25m9rjIFGJfhtmo3SyAdyO8J1mCj0xmnF6so+
         IAGdHOXYNrXsf6Btehh07yP44n8jMBNqIsXiIHyMlYLDgGjW1dSx0x6qpM4Ej2PAzhPO
         kugEpLy6aNJQ55MSxzsQ+kDc8T432Tl1LaptlLri8p55/g7FzRgQyil3K1dUJy49YgQy
         nnZjjzCUsbhKclFe0ZDB0jnh8MV6PE6U/Mmo5K5mkpuUKTnuN3LLfMoNLsNTjpJTY1tf
         LBJgzoHMIkDB8GMCnAOv0je3qKIiyNpJWeG95z2eFCJn0OPY1/95DGpvs9LnoUEp+6v4
         I9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793418; x=1730398218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=TdDlhC4YkMtZhxUmE1s0MT149Bjpqg8KlbVszDvtaK3EjvH8+v46Dh3f0KWEFzJPJ3
         kkgZdPRGETTWgTQPiICk1fCAIglSmEuJIJaphyysxpQNSzKA1/32NwLjlcXhT2pbYr1o
         3nW+y2BErePtWon1CS79cMeSRkJKvAn95n8FCZD5JdHUvLLqSBTiMTXe1TpLHIQ27Qv0
         9iVzHMjBsBIaSIGN+9sYcCgb6m3g3dkn/InXnlWlSIa+xpcPW/Y39xMSDSf14dmbee9C
         s/0WPEMJs/GAH/Ve71CCreI5CtqI4O6QEVtSlqM0VI9FJzoO2rZwUnQQoFhg0lIH5mkN
         J6Vg==
X-Gm-Message-State: AOJu0YxDSc3Y+j4+y3nedGBahvVu/GCx81Nanx/z9JC3322YtUngHaCQ
	K4Ysxw/R7Q/+niIKSWwFjC5NwLR80OFzjaieYpvPe++1YpzKgmQzwhhvB3pW
X-Google-Smtp-Source: AGHT+IHZXi8YxH380N4pd8aJ9EAmo5aHOlsDMOzStKiEhCvdstIdG4pZrvJwhsIcFlvh2YV+pXnllw==
X-Received: by 2002:a05:6512:3caa:b0:539:f630:f233 with SMTP id 2adb3069b0e04-53b1a396616mr4056831e87.57.1729793417930;
        Thu, 24 Oct 2024 11:10:17 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224200b7sm1423749e87.155.2024.10.24.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:07 +0300
Message-ID: <20241024181007.7905-1-vladimirputin693389@gmail.com>
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
