Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA941FF02F
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793425; cv=none; b=IJw5pxIFt7YHgJ8bUN7h/ttQtwbvTvNDFi7WxYC5zIM5hAB6SNgEgK1mC4hYcgWoWV3GSlYu0pO5BbIGmczVq9rtrwxlLtnI29OOd8tbgh8PNeaucdccv7aopUQ/aVA4MXfzGyr7rfhO3GivYq6SFHboDUdarHimXHOpsy9aFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793425; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2dKkNgOdA8PYham6v4djO3TLnPClPJ+/p3Z7vZ7l/23rZYKNqPtORyNLPlbkB8DVzAOBAFnwLF4PqeGVZM3mAUpJn/SQy6PuM0VweRJyPb3p3qcEIVRmzhJO+DpgtzTdZhqQBDNG3q8ax8CzPMphO/DtPSoS8vrpppzbp93LG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkLhjsTq; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkLhjsTq"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so2069523e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793422; x=1730398222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=RkLhjsTq0luA/OzjVVGjmaMEh1aFcmxSdzu6MKRkOjed934DZMc5dRQAEcIxlOfrZA
         lPbre7RB5P3L/LuJj7oQ465UnIQN3W8qjVr6eflvrEekFhpRzyFYJI6pMoVC0GdTw6jn
         QN3vjOWVsCCCdfvW8/nyug+FQmf48ofH6YtKFaCDM/l/am8qWd79No9fOC1MAjBrR6EE
         bwLX1LZ/SPKUmkI8SxaTnUDggzykJiCnpXXcqz1u3a9XuRHhb/FeBi5VyY1pmKsxGUbH
         VyiotfzwfHLO8VfN+ZCMeK3D5obHdgQne6ALxbSFZvJ5oKrE1mG17gBu0eaNE6yeA5W6
         ZHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793422; x=1730398222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=qxO3Mx/OTdOwiU+whrdwdVwE4oJiHURmCYm2fYBa8oqFI2VXxq3gAwnBSenqgkILhp
         gKBlN/SEEl3yB0aPKYiL7Ry/f2iUUcXThSeyc8pWYE6fvJZmBH0X1y91RBzsJcwuSj7a
         dZlbD1GoO2Y0zUGyc/FzaRhhA8B1//7fmt4EFiWfbuWERNXcEPSRevsqHlJrXV+wRj0p
         O97f9ECV2fQXdfoaDblQMI5hpOUqtFmcQNzlMplXdheQH2/Z9/uI5op2iYpICuFMWDL3
         v4Jk75DSc4x0wA9NpeD4RH4lhyqm4fqK3BK1ajT1PLEplhHzvsIh2xyeVXkOowx72Tk+
         dSTQ==
X-Gm-Message-State: AOJu0YxTc42v40xGFilq5xKIwaiKiRMvYLTgHV72Kh9S/ctrFt46YGMb
	t6LsGIoElHRqRCq7XO5t2/Be/0i7Cq/OjW0uA/3RCTYX1VGD1NVkDpxD/Mkw
X-Google-Smtp-Source: AGHT+IFv1fDKc6zkmctHBk9XEDw4MQSmETniSFgbMfTsn+EB+WFmvZCtzxYoEqQhhu+PDCrG6orxkw==
X-Received: by 2002:a05:6512:39d1:b0:539:f10b:ff97 with SMTP id 2adb3069b0e04-53b1a3ac08fmr6980126e87.49.1729793421673;
        Thu, 24 Oct 2024 11:10:21 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22420416sm1437512e87.127.2024.10.24.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:09 +0300
Message-ID: <20241024181009.8198-1-vladimirputin693389@gmail.com>
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
