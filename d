Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB21FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=MH752Sz+34j2fPmyYA4dP2a5GDV/xBSJKOE4744JWDX//lJsa+8fqr2QGwLZz2f1u0ilQQZg2MXtEQdGV20fRwwoQW3c2yZbqwSLcYALSJAUIoDsxnzykimQ9qON1RssdARJWBD6pNP8kpQ00WGlyU0izxWhpfoIt5f4PM187+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9WzoVzLZkA17unPqItUe5ppca+FrDCQCq3VwTYGRfY9AaI51N22T5+zyDXwGfFQkTvvXcIlTRqn/LWbWobHZ8mcoVQ4GXXPHMxRTYwPgejEaqk79nNZwQK6kZT4/JO1PuQa4Xv9fuWLw3oJ6H8pc/5+PYPQ9ieCJqjKJNdX7to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R36Nqz1e; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R36Nqz1e"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb5111747cso12771471fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793404; x=1730398204; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=R36Nqz1eUMYlCXhM8GTwxJV6+MMBLj/CFL5Hkz6SksoWffZNeQrKQbx8TXRHZZLPw9
         eNXMIdXJELnd3dKyPhCR7VOeNf58wBN3dvLAYjAvOxOTACKrLq2aeBgAWb5m3Yn9lU9F
         MAhd9W3tnXjv7f/RAkowmdEgUaOJQuomX7G2TxqC3XYYhDQF5fnIsnZReGCc9CaG8IeQ
         NJ4C9lIQW6RdcaYDCt1X5QhNHsInGl4ocNYwv4fkkBkkKszoFcBJHVzrCTw7FfkS5Dl1
         8bCYBmB+Eb7507ui+eXiIEJKHO7sr1cWUXpm77mXlua+L9AdN6gsLmzzzfaniUeAW+sg
         7aoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793404; x=1730398204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=SS8DtWf6O3d1ZfCN0+m5WrJPLJXL3AdsHQMUC3DmUEw5iS7McuSaM5HXgUatnOAVT2
         UOEMYX699qApCWsuH4lJ2UtA69lWti2cHWkOA0C//CbLF5vLjTFkvJqOgDzxsyn5eUjt
         r7sF9lbL201P0jsC0qYB7K/EVzWO8loAlYpHOzj0W/UT49KKj7wFknuYNvCE2pnmiEur
         YiulaYMRNDqkBqiy/frwNzb1gqu5OgwQELa0MgfNzUW5cEHkQAv050ylGnvPVIZO9FAf
         wri1U/yoE29kebRbG3c+8eVpKNoH7A/Mq1c8ORKAL/fna9NvgpwtKGAKH7AZwQjl4kFv
         9k/Q==
X-Gm-Message-State: AOJu0YzKvjw+SjywAoERqSygkVqu1M7Sa+eIzzyPqeyYNqls0y1VfV1P
	flWRy/jO6vBgTtUGirEb1cLb076hPBFcw195bVyihuUZP+BgSa/nUWMJJ1qW
X-Google-Smtp-Source: AGHT+IFQDPt7gsjJo9T5Z/QgUzPCAiIYOhW1fLMEeq0VWhkZahtkmbdkZBfAsHpfbE6pwpz+32hrNw==
X-Received: by 2002:a05:651c:552:b0:2fa:c59d:1af3 with SMTP id 38308e7fff4ca-2fc9d35a597mr44830181fa.20.1729793404185;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad7a07esm14036721fa.60.2024.10.24.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:52 +0300
Message-ID: <20241024180952.5590-1-vladimirputin693389@gmail.com>
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
