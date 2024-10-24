Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BB61FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=cDqt3ogoKTuvGDnM4M52SD3Cwjjt0kBkObgx5jYvvhOTQxBA85NMIW434+jmKYVTG9daLP5VFzvfg/Bdrj4KKBQLJ+1lPzNbHZ8NaJR7vf/A4qKIrKxmtAN3rMQEAiteVh3GEUu6izWg8Q7eMOOW/SukuUWt6UMXobB199JSgQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFhwJbfgktJ8EGDHEF2J+8q6ob5KxE6hD+3ie36NNrZ4h4IpHCxnr3hJ0MJQBW/6807z/Mb3+xthO+Id2Gx41xJeWE5kJ0MY1qkoV2gE2gtMqAg40Pj/CRvzfJx/12efX61MIhgV4CYElfXLDigoWc8yrFWyT4TspRroTEjEn/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njYIpYkM; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njYIpYkM"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so2069152e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793406; x=1730398206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=njYIpYkMa2FEhK8qJwax+SN8dFBYZuPZDuspc0oOSvBqB/71dBx0a+fnN2QQBh3/PK
         Xf7C4++W7shYnCpMgQm72NxXAE3HznWZs3AZIN8ahOMSQj2x/Z4/MXF6JjGk9NboDEdX
         t5B2sxWMn/pzAugpY57hBkofbiqZEbBX2H2vVDENE3V+EB/MiH21TtiT/B1eR5xIq40N
         sTzLWpaQC7Oktef17q8w8HCHl/tQk4Hj8OwoY7/t/j49bOR3KJbncln+I+4Fu+SPf8HS
         gNrnOd/pCuTItAY+Lv8F8TKwQx1DBJ9BRqds7+8iwMXMz/ZwgavWpgSqmQY5GGt2o0Qh
         YujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793406; x=1730398206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ZTWNqxYNCidKnQkmzyPP0a38zGZ7n7uvTuXHBPxHJGhZdXz2/I+gFkGAa+XgttGPuj
         6llGyQJ6VcTczeziD+7SGbKwG4ZXES0lHtiRfWZCNu9M3NE2eVISkelVmdWxzQwjxHZw
         QtAqv1x1EnqhfRm2qzwfdsPk6EKEjvgKGHTk1b9rg3jPnwWNFbMatlAcJAlaqYJamG9+
         42uzXlqgUqv9RShQMjJjF3pg5akRf0Ld+s+V0N3ZJVoN2va/Gn5VPGunEIRr5ZDG7vxr
         5741W7at81pngzAnwFREVzSWqQ7xZY8s6CaO29a8AyDUa9XlN+RtbvgB+kRyPfOQu1tl
         xBhw==
X-Gm-Message-State: AOJu0YyTJUc35G+zG89E81Z7v4FXZfz2T2WoBSEOYbK1bn/MJxiJXnj6
	4HhIiuKpbd8JnVKIfCRZIuqzZ3kALbl3bcPXIFxUuIsGVDdUCI2F
X-Google-Smtp-Source: AGHT+IGnTod8bD5EmozdMVnHU2tgIA73Zj+/KrOV6sVHnEMDrRpaRW7HPG7+3DwiWse0CRh8JJdjWw==
X-Received: by 2002:a05:6512:12d6:b0:52c:deb9:904b with SMTP id 2adb3069b0e04-53b1a39bbfamr7122481e87.38.1729793405864;
        Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ef80sm1427984e87.291.2024.10.24.11.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:54 +0300
Message-ID: <20241024180954.5929-1-vladimirputin693389@gmail.com>
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
