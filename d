Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8EC1FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=D9YwQJ1KuPBbi7pPBjwbEIbtz4DPfxeki0gRgvqgE+GXkuULrRs0XlvGO3AN8dKEx0iWko8mPNbMlLvhC2pwCVWY9YRwkoZ7w7aJpbJv4DeTPVWWejrU6cG7dd5YqyFphinqfZiLNizW3oPNJETz+lwXWyyL1YdceSAggQ9hBwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/rIPzcM2U/pjr3CfyVrpDZU3aqVEG+jvr8npWulTO+VNn37ODABg7IVCeLMFNLx6svLnNTcDs6CkShnzceobe04jyUKs+7cIL1rjGomn0RDygc9morgKIuMDj2f+1bOU/PUkeqrzG0fzneNhrNuUXbCZAlDknNCUCaiRnLR41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WgaCx9Lq; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WgaCx9Lq"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539983beb19so1638596e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=WgaCx9LqU+XDl9jWeeLC0fucNk5P3/ZumLss48aRRnGjzX1wY9XZFNjSL2Fj/VsfLX
         0LGWog2+F/JBgHsgic3FISCIbnTr/9d+K9ac/Jm4rBCFrmBsjiYZNl+zQx4X4FEZs+fv
         q4tBDUqQPLPcJEeHZw8I4rzvG8R9xE3DfCi1zAwOukWYELM96BwMP6Qxw+eEDLPTQTMk
         2mQrRzqjONxSjVGZMijOZ2+x0A8UrgAb8eotZAOe8Y0RBbePlhQeECmzEhI5jny48DhR
         l31fUVabsl9K/6eMsbLZpJ3FItSvnbKXIUWTSgh9YWre0hspUjwYpQzEVGfg5qQqYuQ6
         Wi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=jQ20PdGGea8HiJ4xan+xTO9fVCBIFua61RIpXRQH545hcvb9+4pk+O9uLlp3vX2csl
         wC/9is2Jo/+hTepzJqecgXsqzTA9QWVA77+cWC9G5zGt32H88TC+mZSRY6QPHzNJ0pvT
         behVg2mRtdmAzk1uqWjtff0fTUVe+WcVBMFW1Mox1U+XWk8d9juJk13FqGzMcbQpR5A1
         l6mjx/cX8XrI99YK1Pi7O3UMGv6K/ezNRZ12tC+NzyHkIaOcg8e2DY2N5rVxzDNvSFl/
         abcceOnMt8lrBT5wxW8yY2PG/+sEfA7QsQi/9K7T/WcaMGz1QhjRefs00lzHOTlFBm8D
         e8Dg==
X-Gm-Message-State: AOJu0YxQ6lzRIR6ug1GnFLm5rzHcjmV1TH/iTsqGSDXmB9yG9EVQ4gOf
	eajQTqh0ZsS4pls5aNOpEpJ+BFsgsobq7fuazECq0hMVgM4fPRW3X9KVBg==
X-Google-Smtp-Source: AGHT+IEO5RXlj3b5n0hYAr/lWhgOzCgT2Jn4hMDk7zXzS7cdJYatyd3OnVcjRx2iXdiiAd32qJeZkw==
X-Received: by 2002:ac2:4e08:0:b0:539:fc86:ce0e with SMTP id 2adb3069b0e04-53b1a341b11mr3930407e87.35.1729793404743;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2242029asm1430782e87.124.2024.10.24.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:57 +0300
Message-ID: <20241024180957.6489-1-vladimirputin693389@gmail.com>
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
