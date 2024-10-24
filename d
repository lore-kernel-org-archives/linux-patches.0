Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315DE1FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=kGLMPquJu5Qp561aU3C+qImiadRqE9ByTmksLg1l4F/VqXvLjUqUjkivUIXPLF/vcQKdlECEEujWC46W//xOMjxD1bKHeHhiLMQWA0HkHFkbvvjdvST9JbvYmN3W34C6omWj4C8wSEiMMvpQ7fiGvDbO1Wu9doxHYhqdee93LOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdwFvsoxJ+UjlevtST59o6NW2W+7KcF5ukrcYb/i1J05Izhd/XlPn3gnPJhGJdSTHkPHbwVXyAhXGkuEKx6NfwEc35OzSoIPyC1GbekdFAIwbJwVaTBvhQJi1cZ88tiAJupPC0Yhi56xgRDysiQ2YmYzkB/SRb6cSygOxH1Ow+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpOFeQ5R; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpOFeQ5R"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb599aac99so13094471fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793406; x=1730398206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=RpOFeQ5RZokicuuf4UxH6YcsBgFrLXzCYseQtTfc77q0HXsmLOrgyhJvD2dq23oXb1
         KvRD+Lnuy25kq3taqXHaMS4/DwOb27h+FzUJl1WKlvMT3GSQiEfX4L7bTS0qLFtudayu
         MFahoFykXDOzgdXG24AEL7s7kUy3S4LRKJYixwT4Jyiue2D4JPoovLWEqfYx2pTiRMo3
         SwgDsdQfRtl+CsN+TZMbELE6cSFxlcHI4DF9QQbZeUJjhJryozpDb/jVVZqrc1qSEkHp
         kdrvu7C974lFce7xNvmiAnr0GxlWrvw+iHcG1cWuxQqeS/mQr0CJPxaizG/JdTjnZ82H
         Xoqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793406; x=1730398206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=aY7ZPqMg/lqE7tOAbi9mlyjWVjUVOE/PpXTEPPqgz7wlOQxL+mFs4l3n+Eto1swcW+
         fcJC+giwcn6yEjXBeXKxgsQC5DKuNZtJVQfAym2BuLVk18UHkL4nNagIrO6tI+C3nknU
         DUMUO41wiRfMtSeY+1FwyfbP8WhBPhalEe7bBUxDPOqKa2EgCWKqD+fHTjZiUv93e9Hr
         As7uS2Bs1/tqi2XnVLV5aVK4ncyCHqvOTqramVoVDtUwAszLDTflh9i/ReRlDgabqEkh
         3WE7fQta8fbKECPrLA3o21dc5T13NsOetbwazY8ORNFqZvKp14NvHkGAGsiF/rLObto2
         wdQg==
X-Gm-Message-State: AOJu0Yw9N/hOJj9ZHEU9HB8UQiEhH0zkcVF9BPgAz4MbpXKgJspANFv/
	UiHdW2Jnrr+lyBtfODhOO4JS3lLQqXKT1QmpGJwfWPYx0dj/ujMBx/ICQA==
X-Google-Smtp-Source: AGHT+IEZcVBPkAym+cixkFEriL53l6alz0b2IZZO1kUYDVVWyILfZyoD6YVjSMV30yM79ojiGQWrEg==
X-Received: by 2002:a05:651c:1549:b0:2fb:59ab:a0ed with SMTP id 38308e7fff4ca-2fc9d31802fmr39947321fa.3.1729793406219;
        Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad4b7bfsm14497661fa.25.2024.10.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6649-1-vladimirputin693389@gmail.com>
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
