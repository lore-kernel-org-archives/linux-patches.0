Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9081FE0EA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793403; cv=none; b=DXSpAALM36jD3eYOoVA99c4f5RdN+ySpqS2ySGepgoB60kkH1imdc0DqRnEr0ZaI9pRcg3wXzy6xPGevtRAwOGONqKX80RvBHhXOrFM8XKxpK/pqBIf+90eAy3Vi1zCWgHuFjYieqCvsoJmiTdbALeLalv3BbOTXlYdVotWqAkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793403; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELWbTRCchpg/EiYSCwM1aeTriUhRUTBrwxAQlBB1+4dzZ/WD6pDz8RDXGlSGv/llgfI1lT67xKUd2vwcKadrUABl8hyPrBvGdzWtAFuwufKl7NVdLn9kIZyKvO7e0oy6v8AQb1hQgz7Ko7/XK6B4/wUg+EFTbKe3dXpGr4uWVvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C18NaD3t; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C18NaD3t"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53a097aa3daso1095139e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793400; x=1730398200; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=C18NaD3tVgNy+vObbNXmNjyh5Chj13GEAsVmq35hntLA1aVRg08RU69/AlZIbzARTE
         MhqKIRL3KwAbNNm1eohUwkc/RgZ8Y21dKy8iokqvF1vjlJaS8z4zlzZkbsoGD8bYWZkR
         mvhVY0LFJesA/bB/wyKMqLpDMiTghWGNPBEt5yv6GGrCA5LtZMzeKkSQRC9ELM6E2r8v
         HNhMheQZXsFV1M9USFnVtM2MrbniJWeKva5ZxtcYmQTUXYxvukBMFq7o0vhSt75HdsmL
         Hg67gOOPOsd1UXaYqmxV3QRkw81EKJy7HYzpNOgqjBwnsNdFF6FjtOlZOHJkG15gTFzS
         jctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793400; x=1730398200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=fCykCkmx/3pxFV6wH6msdUP8baPSHEQJpAeZPa437bdksARi9aSMKAUqfx9Lt1wLdj
         qyqi8AqGZTsdFMYkdcbiYr3ZgpgZ6mw/AD44UsAL1CXf0tIvg0gt9XeT+bRrJcYWtF1h
         CUyrDLUHtLUAU57y7DKrkDHPm3gJUWTmD7CMtI+xR994VjT3sb3k2xUAAtcbe8WQA0yC
         Cv2In69Rlr+Iduob1AR5GT+Hxsl2U0xBLgE2Xg1CXeaexAcV/9IBFyyrdWZXuz6PJy/3
         8PQ3GIbfei8OaR8x3dAEaIVgUYG55U6XhqcT8NogJUnXH3gUDtg54Er5QLUjv7upmkex
         iDpA==
X-Gm-Message-State: AOJu0YxL7fGvJUJoQxpjj8ClQJiofuatS5lV66XWmE6ZrEoHWw6svQEr
	w3zv6vTtD3st/3UE1i72prQ8wULJgbvXhGwZdjcIlsgpvcvs4tBd
X-Google-Smtp-Source: AGHT+IHJCQyT5oR8oDln9cHheCiG71Fc0niTmlUafBSa3GCZc9u6v6XcjKbJ3m+rvR6hl+NEqVsauQ==
X-Received: by 2002:a05:6512:1384:b0:539:94e2:a0ce with SMTP id 2adb3069b0e04-53b1a39ad5bmr4550473e87.59.1729793399593;
        Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5af8sm1425884e87.20.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:50 +0300
Message-ID: <20241024180950.5242-1-vladimirputin693389@gmail.com>
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
