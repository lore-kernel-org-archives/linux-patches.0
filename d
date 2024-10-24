Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9C1FF7B9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793425; cv=none; b=DJC9RjCuauArq21cIEEpmo77CbjdYOUgwTTlKw0T3fJPwYSTjFsA3t4Uhh1I5P2CspX6F4N7t29gyodGgZCkvVxDGpFCi7A4isDapA44yVUQ+0itcaZg3pw1QQOShLHJjz3WamXvPJDlJUuwKZ/mEnAxCvszyevJauJ9jFTDFgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793425; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH2CYDkPtj25fiSIVkasd3M5jc4WefXnBieFtPoFJmr86tCisQrgswlTjzRA7Te/exU/t60SE3dCxjd6KgO6Tcb0vBeN8DochPZBf4pPvNTFW/CjcWk6Kjp/Lv6QxlQGeiynqinolGJGtKvW17nMSrG3YEHf2ftOOkqhDIoYaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RrxGEbnn; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RrxGEbnn"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539e5c15fd3so1233153e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793422; x=1730398222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=RrxGEbnnzl4VwFi+FfwVcWS8+ErT/BJ+2OQ+YnRvVbM4z+Z96JdPmi/nI5EKqKG4YW
         7XCac3HU6SamKqM0zCcMMmt1e4/3D3ytSVrANi2bKCqR4Czv4VUSLnJa3MZjjuxoXT3m
         KZ4gr3BUGYdYvjLKUVeVfDiTYGqd7iCgxOnFJtHHjijgQnil7HNhMhprB17db01e10hR
         wqFIpRlg0xV+L5RSCUcQUsXISqE/+X3YZzN3XTcByXPfWNexMg3WbgwU61QeBEpV4AD2
         tLH/nVYpoGKqZpkIiIWYeLoNebXeI6qKhLe7JC0VmFjmA5v8pulLKr4ErmsDKg8fwBD1
         dH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793422; x=1730398222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=TJW90FOXZXmDUtQl2OlRguREg7zDJTigaCGBws6q31oBHTrhrRBlzi8xTE1mAKEB9x
         3vmXeXAFVgPuN761na8aWdhvGizDmqYQoCSnKPpSTFWi7ZWc3DzsvO+Bxciz72bq+8gy
         X+G0UsGgTZ3oeMVLVWozWmHC5ujHHs7uVEuDGt4isT3YP/EP9gGcYvh7Yb3eHVjCuyoz
         eqhPwA2H1nCkLQwewVg6afHKJkO4A1msZnFGWaUSeOndgWvK4qYH/LJEf8KeykCWbDAR
         y11w6iALmOjK1EqXur8RD/ysO9BN63fbrF/0gCaTwC+6KFN2FC23IoTmH7a5Y3u8sLlD
         P/YA==
X-Gm-Message-State: AOJu0YxWQbla61xuoNcUU9HPFfuobZGGpVm73wmE6fuyOqCqPXlRe2Rf
	1zNrPNBIOBuSKtTFhlHBuWpv7BbIT5xv9r6NvWx6kVhLXbxhZJZH/prA4IOB
X-Google-Smtp-Source: AGHT+IFnruP+VhujIvvNUK/mXGHM2gC86IvBQ1n0RxbAA9zr3UeUSyvxh2yuYrdyI4Sy1BldHttgCg==
X-Received: by 2002:a05:6512:68d:b0:539:e9b4:7ff6 with SMTP id 2adb3069b0e04-53b23e8f1b5mr2095676e87.45.1729793422161;
        Thu, 24 Oct 2024 11:10:22 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243198dsm1435263e87.224.2024.10.24.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:09 +0300
Message-ID: <20241024181009.8284-1-vladimirputin693389@gmail.com>
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
