Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078651D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793287; cv=none; b=MJSrWGWOvqkNX8qOS96oEhddR5tyjTreCVXhrb4axdurEruPGIAmZUXx3sTzUuRvW6r2a50ylwS80ID/CQ9QjJ6IGFxlyx0Sjl4ULhxD+VghBRdwpMo+VwCputIzR7eTovslagyjxpysqQ8KCXMheexH3LQ01nv1V0dr4oWS5Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793287; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZgGsdpPRR6DvxxKnVACmn0PpLvjjbJp7OeJuC/ILHIhkq9yAWpSJcsSM8wehtb6YjqdgVZAKrMy53iCe9bEPfQQO7xD0/j3odoQKaHI+BA4WGQP3prcF86OXtDqfSDwtzJmdYg/tGuOuntXBzuHa5OfgvClR7hPfnkuUEIb3VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wrx4qBgC; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wrx4qBgC"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e690479cso1317749e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793284; x=1730398084; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Wrx4qBgCn1wzCkm1+62JKOTuPa9MMAwCUZ2Wj8KjeJ1A+eIYXKtg4szu/e/9GmBsUF
         cGts7sJ2ndXeXjlN0muKGAtUhDmVl/3672XNFHYyiW8Xmjg4Z2F97FPyItrI9WABX1Ux
         VRRLjxCAXXseLR6n5udBiwD+2sNhhfOhaODCewW8Bb6ylp9o7setvb1PEjib1MZQuBsB
         C4TL//zpCSp12rikGBbdZZdRCqGCXSAjpOEdhUlGC+NEjkEe7fd/eKrmJNgO+hEHAAW9
         odRPDECeUweOwSjf2CsZc/Jsi3gWij+waLbDxLbkQyDPxu+e7M/2hCsS5675DwTpq3ti
         KdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793284; x=1730398084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FjCtUOZ0lxU8mwSFVcMCRKfDa69ud8OrDrya2E/aRz8gI/WKaDlgQV79jMf4f3w2WL
         RCXPFf48NpHk1+XlmVBe/IPWZ5qfMVLeGKqBQi9IFb66eWyJrFASbxp0brSsOcdCzaix
         z6eBwvuxdJaF2frQuXvXWb2DtjXDtZzzrgdYEMWmaeG50SsTrjZCkhX4TW0fSm8WDtZc
         GyG0ux/fzc5K9KdQ8+EtG79O3HVR6NoIuhittbcbfX/Z0R5YukVJO59QZMkrEpaADyc7
         mIHnmwEMweCcTRRZeVz1Jppo2hIiC1Hr9Z/Vj78RUkNi7xA90QB/m7H8mk1320VTGhIg
         JBVA==
X-Gm-Message-State: AOJu0YwQuxXmfhQs5P41dtJ7aDO9S9QxtvOfjMtCts++ZkrRTMc37+71
	YnlNsGlXtyIhYsakSO+tiAd6gmOudTLsCZ94gLxhn9qgYXQTm0y+
X-Google-Smtp-Source: AGHT+IHKL0+gQCny5lXKio4z6yxnoLVTxxhwjuQsJWBvUclE9isQp4ccjnvOCCEIH8kX8Vq+qF/rkw==
X-Received: by 2002:a05:6512:692:b0:537:a855:7d6f with SMTP id 2adb3069b0e04-53b1a345f2fmr4164223e87.34.1729793283780;
        Thu, 24 Oct 2024 11:08:03 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223f007esm1435167e87.77.2024.10.24.11.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:08:03 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:08:01 +0300
Message-ID: <20241024180801.3214-1-vladimirputin693389@gmail.com>
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
