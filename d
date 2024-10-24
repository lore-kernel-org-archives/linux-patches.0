Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF8B1FF7D9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793400; cv=none; b=QjT68kbP3AtN7d5aTRhYL1sSKOTlKYHTkRkn83FwkME2yDY9wxDd1BbCYuuqrBRPffFvhMiew30VbhCS6CoUFIRZCPi1DLxNNX9UiN98e1Lrh345de37Soz+N0dpiNbQXAsjWj8Zd3zP/SiU/t8dzxb16xMBj8slt1OY+RBoiag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793400; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkwE3haoWzPV/Lkoxq9pIB1UGcpPLantRhvQvWUfHO0nEC7/GJTjZQe95lXjF2XVKyPRuE96WR7x37r51AyD8Zm2uWICmjClhY5eayUFaz34xueh4iBx40WG3R6MW7Nab2lMpNvRzCoAqdAhBO9i0G6gbztll9NNYa7PJe+NQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AGYM2eur; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGYM2eur"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb443746b8so13070601fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793396; x=1730398196; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=AGYM2eurCypwBmqgohX/D8RGvLF2yx/2g7Qo1Ka6vfv6YaYfllEn6MSL1vxnKB+fSx
         rg9brOD8/9BnUjSJrsEtQvBijzFJuHXmnqXuvi7qYpQubJzmxFYOjaT2yb/wnSvYiNax
         j6bzNiz3EirnhmjZJKUF/4GoepPAC53YDSTtLBkpUIH7A4GgxgELXNTZcVGTKEDNBSL+
         fh+cZpAk9pKi8NcgtLVDpi1GAPUCf51kG2Q4km6Vzod24E/8mO4fS5iWtJ84fpfexoMU
         FB2Tb7+qBI8H2SNmHGGCk9WSiOw1BHfldDG+a3FUWq9jNx8qzHVcoip2zGb7M2qbQqaI
         Sj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793396; x=1730398196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=rVMJ/BxKIIzJwUQ3YOxcOYe/h5rT//pVs8SwnDjqf6yUN0CXQWyjxzmU+EhYw56+FF
         uK9pwl3r4q1qpGb0pISSVF9zvAOl1lyQYqQq2C8f/aunKmx4+bd64dntWwW+A3FIOt+k
         wORWAWG6wIrsPEZvPY5sin8GtOwOfz7ZwZjwWJOexTRcvZOWczoxOk7/gFKigMODk3wP
         clgV5NFuq9G6EGW1SUfAjKzcDE0Hc2JCLcfkRH4UdHrN4Go+oCiA/XGm53cYIMReyy0J
         jJCyNNo4Jd+3AWrNYk8W1rMYn0kPNPYsFqrfNnaZ2yTLIw1nnBzYWoAm7jITh3LiaGxB
         GhwA==
X-Gm-Message-State: AOJu0YyYgH2E6GQE4Kb/wvMMsQcz29NITjwMIPaXbehYWLsQXQVzm6lG
	ZtvNviWOZWmH9yO+Obhw/TMAAHzMA4+7F7boUDcUETyPCCOyWMZsp9mcdA==
X-Google-Smtp-Source: AGHT+IE2EnVutJt9474471AdoOGwOTw7C5c1Gx67jbj1kvFswwBBtxXLWpQ3LJ+qQXODIvekdiDtCA==
X-Received: by 2002:a2e:4619:0:b0:2fa:cc86:f217 with SMTP id 38308e7fff4ca-2fca8264714mr17246721fa.35.1729793395772;
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad60d8asm14511151fa.38.2024.10.24.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4914-1-vladimirputin693389@gmail.com>
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
