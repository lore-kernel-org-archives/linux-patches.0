Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D1200139
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793424; cv=none; b=n8IM6eLKmXwT9gYCSl3eqCg6AFgDHQWQ2hzMaxVFixvGfnfbyzJcsIXlTn7UJ8y+sJv+djlyKycyhsW1BwLZZo1OzdZFypQraUMeEafDeiRSFRS3n6FMAZXEfzVkmTMJDwZa5hazKWU2jSfP2vbMmvWwhmkL+d50vI7WlupNTGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793424; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QF87FLp13Q8F+EeLvAd4jb/FP6VbDMkpIMXBorpv5CtQNPqOdVpBANelM+DmpbvwDT8LUm5DZKuKF/NzOcDwagDO2hnCn+UpNqJK2BFHV2Tk6/WIa+jbqCrgkGhIARr7pOoMZK5y+JqogXQgqG19Q2Wa45u7lvDwR/z1msrlVRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADeywQA9; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADeywQA9"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb6110c8faso12354021fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793420; x=1730398220; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ADeywQA9NAIxiFxc7xqc0YycF/0Ty+Sk9Iw2ot3CBAiwZNS82j4hT5ZzxcnQ3HoSVR
         QSyec8vJtoVLYfRlDHqMKPz5UBXlVJ4ISWZZll7OT8Glfdcb2zxSwkin262WBhaLFQjj
         X/T00SUCHE60nTkGRovF4JysxxzSi5M+orrdZnYptiLHKfSzVH8yGLDVkAGN18nQtuqs
         YXTPWBqqlW9DxYoDfBPCy0LjK9i3Siu3W3QMHKB/G4m5YKUnGoeWoo66Nmb5Xi7wT0gw
         b9G5Hp5KO4+hMYp9x0zWLDfbQZ3/3kMZX3RBoUvKkiQrc0rOb1nT593FXXHYt9AYiu5g
         Jypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793420; x=1730398220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=DPOvH7dWUFEmZ/ydVvKM72HAOj9hx5r1uFgNbUYTgWeOSeZOlRuYWDZ3EOSwXmHYxF
         z/ebP016VvXtApUf66yHjh5F9v6MLQ5tJyYWE9o0fYdpe2polWB8LeEYmCxTnsUF+SoN
         X+8kmFblP30M7hThX7/Zbt+8xAhr8bPo2cVE/JQKRGPCxtBFP3bBSN6DqwEMveoDLsLC
         lZfovhhIN97OakIGTXAdaVj90p/yT8ADYT+Dd0IdjVUfwoWxiOQ9qO4tcfNQNyY+DjS7
         ziRYOENqv3A6pUJ+DRG1MStV8U0Xx9LeTCDX0WFFN8UN5j6E5o5yz1mp1xIjp88kOgmJ
         qTBQ==
X-Gm-Message-State: AOJu0YywDRnGMgnHl02jIu94xl5fPVVFKmMyD5CE4H/RPhbj2UiKVZZr
	llSIS6+91zcUAv6TYjG8dqBP5Yrj7VUQFIXcpDGjLVM5MVjTanIsZ6KUbxja
X-Google-Smtp-Source: AGHT+IFs/KPlLzj67rraasacO1oNmgRGpI7Tv5h4JFNIV75hRzAxEm3ETUU8jiyFsYV2ofT4QH8zjA==
X-Received: by 2002:a2e:b8c2:0:b0:2fb:382e:410f with SMTP id 38308e7fff4ca-2fca8227ddbmr19549241fa.26.1729793420431;
        Thu, 24 Oct 2024 11:10:20 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf84a8sm14861041fa.77.2024.10.24.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:06 +0300
Message-ID: <20241024181006.7763-1-vladimirputin693389@gmail.com>
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
