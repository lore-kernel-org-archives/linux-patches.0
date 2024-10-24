Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF31D1D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793293; cv=none; b=GbNPhIdN6RUzWmYy3Yemo7eSyNCYDoYq8OhPnPSOsNa9McNj1mYrpktnnGOio74Bs0rMlf6y93TXAD2umEzkfiUu+223PN5YLhzvBnGLSqPMyOO12LfrwDoC7deS+KpJ9HbgMewm5q5qjco/Y0fKawlDdwZxAZL2WQ0kqO+cZyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793293; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hna1WpHOVzlZe8xWAIkgsZFttW3Yms0GRB7qO5cdLHgOGlGtsZIyIDR//+lsVhNcHbth65Up8Izlpjg7+B4kCCpso1KdQ1qMY9fzgzT0+qpizCqMar8w5D1XfdUffqNF/OkfH9KkdJrQ+dnoyTyLXDIys5tXY4fDba5icGk1s6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SkmBMCXX; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SkmBMCXX"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so18865671fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793290; x=1730398090; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=SkmBMCXXEIhSz+WbPtqv0DcTiHm/h9fFA/Nh3yPMYDYovBc+Ovd+WLW3/2vE7DUZny
         ud0JjEUMxP+k2ZwPNajLBxEdXC4vE5X83l+rnqTb+4mDNfLCpyVmzMFU+H3KR0p+/Quz
         6pgfBdMqoogIt0LLHfjDK9WrHhMv4QSVpJ948uTOoMoiSMuesQL86L2mu+ypkxVsOFg5
         +Qrr+mLPucxO07NVYRiXuKhdx6nEEcHvRhP/d+nfe8z3SdasFfUDgZ96X951VH1bNIJW
         vbHGHnVs5fWyQBAiFBz93TX5rIKP5+hyRAYrQn6gR9AW27ifP3Y8hpovfqhR8+454BFP
         yotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793290; x=1730398090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Aewlpc4ZZFtUpcmFwDW3NlLWm609ig+MopDdfLLfNxy8jMPo3WVwUr52wHuh4fipPb
         BA+Zbki3b3q8KY6zdMNofSiBcTP76RnuYzsJKb0/CoomgcegUfSDXJ5yQ1PSVfF86UVe
         XfIPSybxiEVLNluSnV3AgPgDJBoFPYAWHNFmteBAQVKzHvAvCJLoN8fGmKgqm9lknrJM
         nvee09VkzbspVVDMd6eOpeDeRuKdHKMyYVog9yBqzx1U5Mr5z5vS1I1G73LsnlncKboq
         XCtq8Pm1YUXnarS/GDYGqT7aqGQTTriA50ECneGg9pk4W4z6UotYbYPv5TntKogaBmjp
         O17A==
X-Gm-Message-State: AOJu0YzKQQKe02Jns1SJ+JfCxwQjisH8F63/uF6vY8TkTsstUpg3wPHB
	WaqZeHQ6DQ/g7psBpqbKRSWnz8MOB+LWqQ4eA5cHKoUymsyy7yBU
X-Google-Smtp-Source: AGHT+IE2thdVBesY6WZafzHAUN2SBUEokC5S8heeEcecEi0PelFgO4y0/SUdkIpVuJ2C1a/FaCmB0g==
X-Received: by 2002:a05:6512:689:b0:52c:9ae0:beed with SMTP id 2adb3069b0e04-53b1a3ac075mr6674517e87.52.1729793289645;
        Thu, 24 Oct 2024 11:08:09 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ef33sm1424972e87.261.2024.10.24.11.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:08:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:08:07 +0300
Message-ID: <20241024180807.3224-1-vladimirputin693389@gmail.com>
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
