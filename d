Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C920012B
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793394; cv=none; b=oWMAaaMRpPsOWUGq5f3ZOj1JCcG7bOZYDJspw9gX1mFrslrSGEXKGcpKJZDtPKMr1pRx8ffYw4Zqixf0nR3j5+ztK8r9sPe53DdxsN8e94RzfOFiw/3V+xt+a3+4lPZ9bpTzrLsvuQKbdnR4n2VX35b5WvMtQO4ute6xDMm636s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793394; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQSlkxxysH91OiiOjUxxehfBTBQgauKBiVKQDLquF/J6296shQVL9sOBZn8X2Xy2mHvvExV3hHTYY1QQC41wWQsBcqOWS0rGRA8CGsdog6C8wlQfM9Q71EIItODJshHwwqR+vYkex/8mVGHIHZJR2ff30m2WhnBRYPY6R4hdJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQ7vBz3X; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQ7vBz3X"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539e8607c2aso1483669e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793391; x=1730398191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=WQ7vBz3XwlP0RdABEDHn9+t29jU83lOk2/Uha9lDIFGLWM7LvmGmuosn2nbZ/JKpvJ
         qIhk6hL3gmQA6H0A7g0SIu7N8dOA/QnzA1tLoAMB0aTzEOgCBqCDrYIIFd2Wx13lTj2i
         B2kZDMSgG6rGuqLTR4+sjkKZtHE3QESahX4+rNHrbfuCUI3YaRN3iX9L4dQt39wt2Oaw
         eCb/oPtxr6vME9dpTS1NHYtoxh2c2oGPMn6tDxdZScxJoNIBr+v0fY9q6Vt3cUhdsQp2
         mDGtjAylnhgSWqsk98gkVvLYMxdI7na4UVVu6I4gNcIqTPf5OzkPTGKK0/DwddvPQ1ex
         bDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793391; x=1730398191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=d3C6YgznQPqAp0QfhF/vTCYCq/KhRCdCyDiK32QObUo6d3JTmXHta+7ag4A3nffrQe
         tVy01nxEAJ/rvwMNf3W5c+bW1POWdPftLIHMVxn02JwkRAN6xD23Iue4XqvZejDDWSS3
         Et1nNeisR6/bsC8rdZwSdJeCnTU/x+bCjd8St+6fS7tUO9NR5tW/Bm4r3tq6D8LMIYZ+
         n/DoEjhgNfA19UnhE8obtO0Ji9l8QLm3r8Tv5D3UJLklRDq0aoXhXGjCPgs36jz0+uNN
         HmLa3WWRbRHE2URbsEpfynSUpv8c7JAh9wk7GyB+MRcIoWyE+trGAmuQugjuuXdOY/eq
         mneQ==
X-Gm-Message-State: AOJu0YwYrcVW9qby9NP4dSZWtFEfs0HXIjEU3S2CGNIPqWgM45m4/0UL
	aBlracdT58yMi/669CTaXrRbuYZt8QpGTV4OpidhCz7FXJ6SK5pD
X-Google-Smtp-Source: AGHT+IFaYLBvvGq0X0oVyC6mdghXNs7DfcwkEJRo3hAIHfR7UfEzCm78c1WRZLs7uJevqqqJuG7FQA==
X-Received: by 2002:a05:6512:2399:b0:52e:f99e:5dd1 with SMTP id 2adb3069b0e04-53b23e69b32mr2213307e87.47.1729793390500;
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b137fb90esm889234e87.296.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180943.3638-1-vladimirputin693389@gmail.com>
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
