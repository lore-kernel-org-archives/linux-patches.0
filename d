Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260311FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=nhY8miRxkAn4jc41fDZ6zAQS3PM0DCyjyrwhjRX48k4Tp7i8LhcHW1+v0Nlscv75by2BgaQ/fIv2dXrNuM4Rz9MRUIBKJ58p7hOgCoImbMbJuLgu1ak0r9u2Z2BrOXOeeVU9xpKdQJeejM07LYCKN7M2cjZYHWmt8Z+wvOvvrMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riC83SxquxcnIZ5vjjBVF9jDEvkK9eGjfDmhFhyOT0kbDgorQT2OM23M0IULStZ7/IC3L5SxwcyuYHuGN74UzKq55nuqVGXTOjJo0HtKNGEMbV/QYmjoJV3/jVlbjV1xBjNrD4yjrLtnclYRxqGvA99j6Xhg/3WCRzJoMsdT1YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LB/Xf/wg; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LB/Xf/wg"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb561f273eso12388101fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793404; x=1730398204; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=LB/Xf/wgAY78Kq17OPdkW4+G6Q27UuDHZ5+MFiy0G9/+lF0a4lG1jEaCWoPCltTv3x
         jRCT6qBf1PdVRFEg/2dc7rYhL1jUR8r+vEclL9Xfhxe5yzpF0f9Xl8i97MMkeS9xPZwC
         iZ/4AVd4YP7h0VKG1+Ftd3qJfE5+4Y9Pbt3qTBgZgnBVPYB5Lu3ELh56VTNPFvUBCrCw
         RzafaKfWDpKcbk/Q9jBm1+0dbMEroU3Q9t68Nmq8XWrmS5WWdIKd1sS74Gku0Cfcrmr/
         jN3z9OK9ZvXeUE4sL6Orri1yavoLiQd2BfTo7HqImF6Cv6M4uQe34/jt6Rxb5halRhHN
         JpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793404; x=1730398204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=M+CXjXIwnV2hbYJCblfApMNzO0RFRNAoBU3MI0ejxIod1fpmekAf4WSPS2ISuVoKC1
         BaNvWbU2ik8raQHcJsGCTbjpo+y8+mJEfWwhboz6DQNJm5uh63Viv8e9x5BxH4Fb9x33
         yLvt4ZkonrurEdGg85EameWu6CvvL6PnLEqqKmJ67UZTbM6qcCTYS/arp97avUxZVuSn
         tAUCOmztDBHW6AMAFa//DD3nG+Pf/KTLfs8CjD25gRJrJ8cO6hbQ9uY96q5JCQaNEWaO
         cS95bRuIbVUj7qTjTqQB3tdykRRHLQjXTLQNKI2ILNln/RMRsRlZi1pzXiT+QDei2mLK
         dpHw==
X-Gm-Message-State: AOJu0YzPPWobA6OpymbO+SSA2vT4Xc0wwsVQHgULfMi6zu6u+le6M+MN
	TNWYjQFI10uxF2L09aOv5BLF17YURey55EkxgOU4WlNxrtZoEH/F
X-Google-Smtp-Source: AGHT+IGcpx1vOMaQHBnd5akWRcqHc37aMk6qwsIRDGjJY6p9tlTQFChWO3W3/fojf0KDXPmkg0bIug==
X-Received: by 2002:a2e:a9a4:0:b0:2fb:51e0:93f with SMTP id 38308e7fff4ca-2fc9d60721cmr43935731fa.35.1729793404065;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf8562sm14427951fa.95.2024.10.24.11.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:53 +0300
Message-ID: <20241024180953.5864-1-vladimirputin693389@gmail.com>
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
