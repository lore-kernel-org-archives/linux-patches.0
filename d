Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CBC1FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793406; cv=none; b=nrNrx6q2jJ3Mn7scmxUFb102i67d9Lvn1qMh4LdEtur2vXbq74fAvvV76pMpsctyzpjOucNgLRG2ZpPiwq0jnz3XmF8JK0c5ylv9uEZke6lM5w9CAaAYWHvw7wEVDs6R17HJeoR0mLXKOksmL3VmsBP9OuARvJhV0yqNVpRKGcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793406; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDZeVJ5pc7wMzC3IYPvQRSa1foyPPCRppICpbp3Za1FTR8WxNzFSnv47igONoV1m8z5XxkMZz9GKQqY7/sFHb8kzd28xOsw0F5kRX1eFtcsFtPsx65p/ypVFNcd0HmamRVOXGNZxU+yYeUTlMi+M7S6HCPvupYdiJqctaJejVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbCJYm/D; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbCJYm/D"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb4af0b6beso19346361fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793402; x=1730398202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=jbCJYm/D8ydhQd0/ocWQFetXRrPRNylhb/s1kAog/ClNhH0/iG0cTFbzYBI/9TUkN2
         spYZwZAJeDhRpDdEirO+btfIxYeS4C6WJbPA1XE6BVHJQEttIOUx7kBnYS8m43r2LTwM
         QEcZFoPFQ7JI7ugZBPpWnCoiFkioFlu/PoEGbvQZz6WMpR1baoMKEC6PI73UW34YPLLW
         zcxCpDigTrmEFYU0dYyL8CzYqOD6Yi/OiBQ1RS0/x1j1l+4gzUZ8wIgDRkWp8t+lF69n
         lkW56eD0Rh40kEi+90lTmMS+qCfMz/S+0rGjquTisiNO3ljs+ps4J9mMA96ReUGSBAzP
         BkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793402; x=1730398202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=as5hPK3SkUGW5oO2QRl/y4LobsoXTvJn+4TFq5t4e6U7J1AhLPU3y/xxOmweY53biH
         iFGfxeZWzcbT+kijWUw7UCNeId4oE4euxGaTvvIm5j+YROwZ6crDk+Q+rUR4GZMiQVdD
         mmDWUhADBRNkX3hpJ5Lu8gIkJbXytKn41WWkw0buxHppyL+lrgE0/XF7tXHrKK4eL8C9
         hEAN/3qJGmT0/cm6oQ6mhRSEw1/9BztXcVYWdkzgE7POEOoEC21z8Q6mPCqW0ZBxGJgG
         njKiZOJjumBjw7jo16l5zjucdaLZGKqAZ/o/NzBV8+ugX60aQ7jXNXQk+x2bwoEB6Jl1
         CCBQ==
X-Gm-Message-State: AOJu0YyplKec5YwJl6tHid8so6SDbESvlZO2031JgSJ0jzqnxI4EGcPk
	KIMBAudUCz0/CTV5qV8UKrCxWI9dUOw7iFFzfwlbHYCFIVG6KIj6XSFSvt8G
X-Google-Smtp-Source: AGHT+IG6eBWH6Cf9DULaRHG0Y+mLeSTVHyTn7jxRF7W2TNikWJIPaFK/y83il3Sb+7kekA8SOOeVFw==
X-Received: by 2002:a2e:4619:0:b0:2fc:9869:2e0b with SMTP id 38308e7fff4ca-2fc9d33a195mr48902211fa.20.1729793402074;
        Thu, 24 Oct 2024 11:10:02 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad76132sm14668991fa.51.2024.10.24.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:49 +0300
Message-ID: <20241024180949.5068-1-vladimirputin693389@gmail.com>
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
