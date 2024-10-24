Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EB1FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=BTWxWRn9i2ncFq7r+IOMkPybCzhRLqMbX+Uos2fEloZSOJRajAZ0Q0ZTmch8/DtBfgIGKatUpsZjOpqQwWeKXtzK6NUXSuHvMoITBts5G7Z9NJUM4hMCujYg7t98uRt9JEdaufcdfkllT/vCXM7VvKb3mHLLMbPasOPMMff4tFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciELzpz2ZazsYNxrX7Ex8DWIdCHv0/qIOwhvXXsj3UIxmZVLXVvvRUrzE7TwIUO5rdTbN5P2V6lYRemtPyHqpd4oixjwfuBIVkc0gBVgQ5jNWGOe+HGPHWwV7Qy+sHZ0B3XgQKwGoVNT7tJlBQ3p7HtT9NQCfdzUkorZgenXD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kK2hrxPA; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kK2hrxPA"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so2069162e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793406; x=1730398206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=kK2hrxPAajg0f6L5MNKkXUjPufQDgyVvri5+PwrZ9A1mROi9ZjajTAgSYvebiDK0G0
         R8whb+nTBypmeyA6IwdGm1i0AW1HGbteoS5uNOXohOCnogQPxZXt32Pg60lwniCPDVQq
         SjpjeGBog2ZF4+gFklvGBDReK3DPZKxH5i5LPxegvQ0aY3kgfQSKGSIsWttZQuwoUs2/
         mK+9viAyBQRfl+T7Mgv++PfCcC8kP0+NYcxrR7pmsQ92z1I4LK8cuAMywUeqWFuYhfe+
         MRpORnVXAaodEmt3wRWLi5mfEHwoAehxqwBjZV8AmIM/ub8fDaCjaj24np0WSFKZ/got
         uXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793406; x=1730398206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=f0sRAykol9gVexMH/V88vwyP/BT4KjIuQ2lTkf0m+AlqBmZlzP5Sb4u458B3FVuSy/
         ll+wKDvc/r9bfHjg/gwlcPBHa49ifNV5tyVA8kloccQl/h2Qqk08/qnDxgTn+rc1b6CA
         EfpsSugtu5IeGffnBkv2ftjVyRWmx+vo7hBaZRlkfbyApmFwLU1PXWSnQxFO9cC3sUlx
         ikfEJ/tHEoIZUj6fevC1zcl6Ew4f9G1x5i635qdHGPL4Q/x/qzLTCc7xS8jGgNi6JoUd
         f/NTbCJRRXfRTDmoUhi61TU+bBFV3nRT2rSfYQxX9sckYdThz0W9tXGLDEPv8XYkc+Dq
         Tpaw==
X-Gm-Message-State: AOJu0YxNQ7Ub5PCqCckLgyx8LUDw8DV2urS7PDnVhXj6AelU1MQ171CF
	+0dFE7Tt6jxYBDCtKoyAvo4ObnUtpbE75J6FSYbhXOjq/crRXMIhmL/DUw==
X-Google-Smtp-Source: AGHT+IHZaTqLXNN426SdHYpHPfVL3LelWmo2WwrIFAsCMaz+/Q77yTLxcXAUWwaT1YihE4H8/np9Ig==
X-Received: by 2002:a05:6512:130b:b0:539:901c:e2e with SMTP id 2adb3069b0e04-53b1a3b0492mr6536198e87.58.1729793406220;
        Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b2b8860c3sm5787e87.102.2024.10.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6609-1-vladimirputin693389@gmail.com>
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
