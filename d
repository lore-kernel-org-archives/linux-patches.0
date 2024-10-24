Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1511FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793395; cv=none; b=X03G973JGm1AHgIFu3B7xlDCbvKh2/flqvZ/ixMSAZSfP+gxcq6AiSlTpi2eYE7vdiqZNlWlpBgRVzds5ujaSJzGt/or/TkGzxPWbCwD5sGtgQ1pCO0jTY2YA3xA2Orcuw5EjQzV8d5aThXpYsP7lapdb48PBBeTBYaPW7gDm7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793395; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVK71v+Pp1wMfVBC5fZTUoGlXc2W9vTNf0nOKwpECMA3GdtYFBrxA2cRDMBYywt2JWRWLsFobg/r0aXCQSm93OBSSwEcAg5zelToGWEbRlObtZJ7C3fpKbY7l1nr1coz7tBPiSArRqpHpHL0kMVD3mz1CBXeQiNwWg8T46aXgD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2PyhlBP; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2PyhlBP"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb5014e2daso13067331fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793391; x=1730398191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=i2PyhlBPY32Is9iBfX0k+6Y363B+hCJOY4vTy+AJ8WO5sTi8qKljKTIy9Qf5mEDwD9
         smIzNwPW3K//Ca9ZGmQNH1Jtf8E1d+0dNQK9q/+4x9YEmNzr2cRrnQLiCeu3hsV3Pe5D
         QXRraYDZAPM/NnRSH/O0z9S41wL/3J/kWswiwhZc8CaUqY39IkPjuACWRU0AoHSWLMhx
         Htehe3L5FNSs4uvYr1xbtbbZQDUilNbnxiXLru5edJiCLTKejRkGQaVT1Tv/mP48N26f
         QjRfdDssTRau+2VTc3eOe19eOa8OfoMWXBmH6/uo6Mj0oPhTrZMtnFPPm+ShZzI59fFs
         U7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793391; x=1730398191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=N8Jye++ZfmKSHH3eRssA9/F/Zu0PHytzZegbM8oVGEQlNkqH7nBLLadRu0jNv53K/B
         apOgvb0zCBJE2oDJlOxfh6BjnY/xqCt2n0EDzCppyY8wWQHqnJ/2R24H1Y+HpK22S5Zv
         Pc4ugevt8yqtzgjoUDAstguNXdtfSEIkRdxnbeQPHpS3vtXupsTgiDZyd9yIVEh/n+LQ
         ZAowGV3iA4PBZXRd0KS8QRg5q8FW3YdOefy1wQAzVjRWlyolKBDTvwWpyqULN3ou5I/3
         +x+M4uZF8Jm20EGt9LyppWX6L+OqwEV1YkE4xz4Y4T18qYISq4JqWrNULXPpaAWXQGrE
         UwWA==
X-Gm-Message-State: AOJu0YwWpYdTJb/doMBvz7ZArq3PWSh4nkq/RA+HXeKfjVbGCSBC0HlV
	1+77KRMtd5e+wkSj+paYEqbJ5br/zbAo3Tdih4qb3Ors0LlzdAxx
X-Google-Smtp-Source: AGHT+IH01Kfy1VH7FKAQAZXd6t04/o3LgiGIyl0zjMpVZetmgegJykX2Jvr1S7bTm80I+kM1fS9h3Q==
X-Received: by 2002:a05:651c:543:b0:2ef:243b:6dce with SMTP id 38308e7fff4ca-2fc9d2f5ff9mr37900781fa.10.1729793391118;
        Thu, 24 Oct 2024 11:09:51 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae25b7fsm14664181fa.138.2024.10.24.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:43 +0300
Message-ID: <20241024180943.3728-1-vladimirputin693389@gmail.com>
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
