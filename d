Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A61FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793422; cv=none; b=K9QLvRJSRvStTiU190vY6kHtE9feJr/nnJ73/c+MmcU7r1asL0dzW+riomu7DFRxkEsun2Q7iFnBrjSofwbdt0Ig3juGlKHiY0DXvNWpn5Wh2lb16ldSK4TaWzBLRhaN30cg7ykpt2RiBqX4XaauQGgH01yPOF0wLowyFqm2qMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793422; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3igLeYWIur0gBqNY5W0zuc13apXk7I0iwQ7aFkxv9lrjOyIPxXBmQoef2Uy98swH2D1+eM0AOtiNUakShMvhDE4BmpMKiBJP+Lel+uNbff2ryprcz4k8/siOVDJxsj7kyQuCeQt12jrZz69Q62Wp0Tv4OK8Duuam6SKeYkswIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqWYx6Ub; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqWYx6Ub"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f53973fdso1015923e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793418; x=1730398218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=NqWYx6UbAVwzINk8ZBakMArCtoq5F7D+LCby8x/2nhrWGw/rxTzcNlOlxlRcrPbZAw
         rKsKWz3kAnvE04AHWZx+xFVgF0I3RL9/XBqyhhh5c9qCRxC7BxfedyMN5NMJyyLWjfa0
         W6GnCFBRGKrHNTtb6hz0eKiaq8/ExFrp+ijDkZjgqDF23nuuBlyo7NM6UvuYQk+/VaIU
         IsPjOHzBhk9lwL0vrsOuLku3iCmXWpFP3t7oXmnnumreTtUFgPd03x6ZbyvcM/TY/5yX
         llKMr/fn6A8T6A2uAUKPPpsPIWpKCgjqjpHtc5zMr1Qqx8FP8LdTPmX4AbImxmN8nCTX
         tr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793418; x=1730398218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=s4tgAE2Z5l8ce4qJ1UsXtbB1+lLvpxRSYnWkcSt78ORxRGJxcrIGqwzQWyCnF8Zhve
         COans1uwpdFARFZRJ73GiH/KsxlBND8bDB3NQC+WdVQaWn5dDRf98vNiiqEg5iUnKuDk
         ilOZ5i3PP+Z9H6PKGKar73Zp1ZvlUTcL2vn4tvgy7Vdi+tbYIBUYIzCS9BklNvPQwJ9k
         /8Cfrr6H0sIwPRbiX8pCBwWFnpqCgni5fxuy6SQJGx9phYVrvNEp5+Dd690cjmaCKsxU
         nHno4cAAcHtYvelNPCm+Vd87jdBipBv9cUxl7ScPJoSMeBvmx6LpOaMNkqLRHKEcKUjy
         sD7A==
X-Gm-Message-State: AOJu0YwDUdHNQfQyta99UBA2q8QqzUDbkB2W0p7XTVPi+MJix/WG+1Su
	Zbqlt3wmhqWlb2/rF1iMcOaq+YfYXsfhxyqd9tqJGVPZSKRGztEz
X-Google-Smtp-Source: AGHT+IFd2C9L4dzQ3J7fxtzb18TV8hwJW6uyPMhDd6VYayCRKWi+2F4maWqUa2O/uGvYTlA981WW/Q==
X-Received: by 2002:a05:6512:1252:b0:539:f539:73b2 with SMTP id 2adb3069b0e04-53b23715578mr1215872e87.12.1729793418366;
        Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5919sm1432453e87.36.2024.10.24.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:09 +0300
Message-ID: <20241024181009.8215-1-vladimirputin693389@gmail.com>
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
