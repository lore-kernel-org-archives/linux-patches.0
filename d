Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBE31FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793401; cv=none; b=BYiy61q3G1iUxvc+Fqy7E0lhmEkT0kTnfNCTM2q7xdwLJDbW6VlzCigMj6K4b12lkBQo80VWRFB9OkmyXyCiMXu8st6Kln9cJvOJO8J8v7F0SCopQ1pyLjKMUF4tW3BzQbeTxY5HWfdTW4CSlhu47URRvIn1s6tcoBLg1nX8A0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793401; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9gbOiHMPYmNJ5Up7UJNdS8aLsotITauwhhKVRYX6vVxA7wCoot/8NJO8Fbrs8nhga8Mmzd1+6XtGE60OmoHFdil1d3DzC7ktonarYUXgUpAyCpyUy8W3MhZOKWqo7egsXrZpF5U17u0kWc88XIrvpXzanH4Zxu9a90zodvNGbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=krY61mrq; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="krY61mrq"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212476e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793397; x=1730398197; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=krY61mrq4d1I7v/jCigMdOV/UGP2AdC6CUc3mDQc07aD1S2zkEPXubDHllV0jHxrqc
         /VQXzaUWv1KgFEIvV7r0ECO1BaWcT0siV49Fga6CX99N8B9TLi87n6xDgUkAimHmBrMS
         mPguJiCjyVpg1NyKFuxsHluFsI4cmbFUd2BaLelap5hOiUo0CMwES+lpV8Rbp61tbLPu
         x2whDI89+lVtIxhjW2+dlQ9KcQzlgjBSuxHsbkdksL9X5A3bLsK8LrgnPRMir6lNlCFB
         uSyv+R3Yj3Lko/SJR6dyKFJlZa3fXtsG/Ms8Ib9Vf9HwVL915ZVyR1UK8+5vB5DWVZV9
         yykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793397; x=1730398197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=MS0pO7MLf78LktkDME34UjCf2S+/5mdMCJGSTW613tdrxjQGw17uXhT2tmeo77Htcp
         VudOK2xpgCGAeK6r6hbBf+NkUlQER1m7eFzo5rOmjPFJpyMFh3DMFCQBHRkv4D/rs+Gu
         psG6+AYkkC5ctB36h1pAXdxsc1bnP0nKTI9al9FPDjNntZdwRthRrIK4Fpemaay5jlOK
         gV9bWTMQKYb5THZ1STWh/xQeeejdpDzmgd6Xt8j+HFTLqgKoR31KFYrFm9ICAJhnA41v
         B+HOybtHI+5krs11C3UXy06B4+EzUAah5G0HJdnrrM1B6MFAOiUv1uUBIbJfgvu6FV3p
         EIQQ==
X-Gm-Message-State: AOJu0YzNPrEAkFju895dcYDslOxelzbrLdhT7fUqJZkbhdEc55CwwTqK
	dHyXlYiGNVqOU9EGAu62NQ52x77AEtABSkOPccSdiAP80uGiF8wt
X-Google-Smtp-Source: AGHT+IHIfdw/6UnJpZofdre7hSIMTKAHXkI+lcgalv5jQO8w7rWjFiqdx+xmppooiw36TwRm7OyLBQ==
X-Received: by 2002:a05:6512:1293:b0:536:55a9:4b6c with SMTP id 2adb3069b0e04-53b1a307d85mr4645411e87.13.1729793396956;
        Thu, 24 Oct 2024 11:09:56 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5ab6sm1433654e87.13.2024.10.24.11.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4760-1-vladimirputin693389@gmail.com>
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
