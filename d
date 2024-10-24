Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC81D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=nhh0vuEhQcBqB5UxwYlwAa8KwmAUkbHavsAkZiOJOQ3BNzBYKi1LpeLvxPfQDRTwjOvQbV9xQvbJmjKx1SNX9GFcHQ8Pqldpb3gIRdwVB+GsVM9x/kqvAH3wCfWGIKverz080NxC3MMu9qKAqXkcOE7SALFsxPItWfY//WbHiO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKM/cPrDZiOTkFS+fmTJclAHRUIj5fkU12l3mTYwpuzt/gg8qfYl6Wi42JZ5n9JAQM7OV5buQCaWbksqcuO+b0l6jaCUUgj76fjqPmZHClyhA0hG6e5JfZcL7LjLaa5CKUSKloSmyjeiP2NClfRweo7N29RzGKxSC412VZ+wjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=liu5zmIN; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="liu5zmIN"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e59dadebso1586142e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=liu5zmINAI1BLgeHgIMO3QMoXgLsPbm18eef9NXJ2IeNPkJSvyG7oH6G+S3nMDqzBk
         7IuxPSJP0YcT4UdrnoXbDn1RHFas76I/NH0+HdZcar1wvfo6qQCiYDYLUpLDd6lkXSbT
         viR7wfTZkp3cAdYEq3iqjpVXDcW0ljtxjx6KVsuENKU/sMG5ln+/F6IYWxRtAl+M7PK/
         pVAubjV4b0fJj7NaYMZOKppdP5RdB1WV5BEeF/7kSGvvLUN69f06/qVHzOPnZSMd2jVx
         cdAvlgW0RVuyPPOf50YTrsXtSAIXt+9Kpz6/CZW0TO2QX7B9VHnNw7EypD/0h9tGyJ0x
         YvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=F7TceD1tMIsD8QjAOMWad7dcyQTAbpio7dzBlhSCYlOga3UIbyqUpA6QFRl7rnHhwC
         DGPxeymWSm3ZkxHXvGZuBWq/OdlgOa/e8FkS0XP06GiN44H30bXOwlPbrAhDcOmsiRYd
         gATm8zJG0CcmDwOESrLTAnYpRfwBmmTBtBAYVXxPrlONAIQj4yjtlzJEgpOh1IXM6zMB
         1w4TWjCKY271t+Nw/jDu7UsqeySrL6Vrod5H9I2HIcbHLdmbCLyQn2oYCs/yMod3PetL
         PB25xVTjWeyFETcE8gaH9JUQDSAecD0mP49ijzWvmDl1pFlEg6LHF78OjffOTzdY9YRm
         Ku/w==
X-Gm-Message-State: AOJu0Yw8+mSB6D/uYAQEuLjygGicu/LVd7Cu82KWuGkJgh4B8ZkA1pTK
	8s+8YLDhAuj57ySRYEKdTNCxAueyOR97SPAIAv9tX1fTipgT7YzA
X-Google-Smtp-Source: AGHT+IEVmgSCitNzELwehqta2JFoJTw3GbTagZ28JT5NiK++A6zzCfbKPT4t0IB2w/a6yMzed12kaQ==
X-Received: by 2002:a05:6512:220f:b0:539:f886:31d6 with SMTP id 2adb3069b0e04-53b23ddcf0bmr2025281e87.2.1729793387004;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224403f1sm1429679e87.282.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3303-1-vladimirputin693389@gmail.com>
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
