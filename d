Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF41D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793419; cv=none; b=STP1HpBd5VYoyx6MViB8/xkecOAN+EoDCZmFcc+7DWVO9uZteqd+f7k4ifPmmENYsWEcNcV4P1VIuRuPSDvFKUsCNUEvoOcdok67W2l6z9DKLfyqmLMDJ45+S7kXzTjF2ziB7Ds6tWz7MVikMz17wQM0Y9Eo/h/XyOIJ2Jndrs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793419; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxQsOShPIJa43oeWMGNogqk5rDhV3pUtpuZ0q0xEZPWuBkgxkoVtE3hpyLGxxwE9HtyU2RM/ym7WWUKnTLVWiT3Q4PVh/oe+/ejfHJ9T4/hEHAACw4+1a6//mQdZg5XVCjEAt1HC0pP/Zyzq523c8ZIszQ891vMeQmD9Y1poQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZDKK5ZVj; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDKK5ZVj"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212842e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793416; x=1730398216; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ZDKK5ZVjr3cXkkv+F7kiulsfGWbV1gVooHy/i5oWf4xGHL9GnPMmlZMvA1Cfz0qswt
         lB4HMvx7f2xqiIj5RONyA9HDFhEa6bz/o3PQU7Iw5K/yrYBUgRuXocb3ScGHUTRToiSe
         UnDra75uY2Q1YdclYl+cOEX4eZ+6s9aoubugkQonbrdfbcOU7X7EtqgvWnFSIazEG23r
         CDikAzJ/iqckVW1bklzVUHSnMBoAxrWh60ploX6ETje+1K4lkTj4x/XDBGTEi9pHTqQN
         ngoYkWZDJUfC2ce14wkHC8ycGHMf1wyMpgs7KfcNpq/HiK57lzp7tQYSBrkqqOQq44eg
         5XJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793416; x=1730398216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=qe9dfpMAGPjjW7QZtSU79aGsBuSAAmY0A2/E1Wl6T9fe3WxNw7/LUrRhMVG47N8bXd
         vvfjY36nNF+n/gk0EDqigSUeYaY14oA7zAt+HtK9hQ5RIy5yp6HdJ1obx4MyRhcR58JT
         dGycLDt206olN5MeYduqwepjSMKvXCoVB520RyX7teUigFw86Ch3pGd/bDKtur1kZ3v4
         aGAXR8zz79ikjB/2PwhQOOgpZfg24kKl2k9Q7hR5ZQze96BrU029lYZwYvUCHKXJawEm
         VEk4nrJR4c+ZYXv+6zEMXl4UXPaQQgrYbmRp+eoT0q9h2+oQguNJf/Utdx7Ew7pywjK6
         ntbg==
X-Gm-Message-State: AOJu0YycClw8TenACY6fGkzxLldFN/AaIk/9OelJXtnQ5EjxNyYzEwq5
	ygFlVCfqoH1gNzUnPOGL9AhanNybsqh4uHv9EmTMGdrzZZbPSBH8J8JrKWUM
X-Google-Smtp-Source: AGHT+IH0gVQ6bmFM+cKzYpG8UnjxL6VE2ji350IVST2k/IjukgqqKLo0qSJ2iUmzcJLYhIEZVW3AKg==
X-Received: by 2002:a05:6512:b1e:b0:539:8e77:9129 with SMTP id 2adb3069b0e04-53b1a36c6e8mr4277240e87.44.1729793415869;
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5988sm1419785e87.2.2024.10.24.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:02 +0300
Message-ID: <20241024181002.7203-1-vladimirputin693389@gmail.com>
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
