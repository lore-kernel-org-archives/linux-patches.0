Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F951FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793425; cv=none; b=p8h54M8Lx1nNs5FyphUlCGsXyTRNOVYUtBb9q2frh/eF6xoyPfb2f8M2u4dtFrEH+/VJ7C+V0/45W1n9XGSCD6+2zKPlbIbVkCAq/YjlErHWM6zYtewPRfaQOsUS0MdL8HNSx7MJd8cw4eN+bnBP7bwGu2tbd2oQngX6xULtxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793425; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COMUlgHdZ8lBCth6i8COUd96ycWfCHS8uNh7aV8L7RBa+25QijSor1VQ7O6T0OSDXFjfsQ5XgK708rTim+lc3O4KjKNPnG+5Gl3WbCmBI/ho6HaSlE0F+cmPpyMnV9UVLiW8cAxALAM6aML9i5bP6BXf2QI9SFZCRKPt/aBdfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4GQwgcN; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4GQwgcN"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53b1fbb8be5so1485968e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793422; x=1730398222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=H4GQwgcNM5ub4hdAD+37Xsz4lSEYyyRn/kRgQvqrKeYJcpeW3X+hkPRLE+nw9GdxuF
         5UTfg6TEypVe/EAa33FJwKrcDRtVIEy/J+IJCnCSzEMIwn58Vt16yTmiWfeSxkmJgi61
         atdtjXavoYFWRxkz3pHsfwTwcOgZ+mfBIrQ8vNnnzjebWmt33tIJpx9rl5e8UVTSFFAi
         EkzvlLrK7bkZbhK3BCfLyKPIokQcgntepT+LEV8A2FsXwN/OULvzXWvqP6kA+gmjAnbV
         yKGk+glNQMTl21oh/suofXBp5jQdgJDJ6142SHUGUZD+EYZkHwFVF8wCChbFOxZQmGMh
         cRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793422; x=1730398222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=GVuF03QFT+pC0DFpvAKjsGc20tNHV1YK1gZAghSkRs3yBlOAdBTdNU1nzXQ+gAANSy
         q+oBl83p/fNDVvuMZFI9yE9Zw9+ohp99FKw7Cypl7MJM134OhB4KD+A0OsCQMaiK7hQb
         NFBEL0KNReHGFwclofoTemT+ppbHl98sxMW3ZDPW7XvXZJN9kSQEng23jlcIleS3b5VC
         8o7v5mQG+0xtgf9Ffs2R2g371foaTgQql2dgVyZjwJYvKYdv9LFVwypNHBmq2mNHwc0g
         EX11cQ/E37VJRUp4ppXrr1kHKUENoFx85+HcWx0gg4cXuxrbTfnUuP1XU536AcdlBh/B
         PYeQ==
X-Gm-Message-State: AOJu0YyXWOgdhK2UzQxPC58v4wzC8h1MhDXyqsLPNVvZVK7NdssTbZtl
	fDZNvfTMQ4933XFIjDiZ2VIWZFkKDi3SatZqEjrYp/eYrUrPssWUxIQZ/xBe
X-Google-Smtp-Source: AGHT+IF6RNH+CUXTFx7mgJAoYTnjaHqXrxOgUd7KecMsU+U+wXORyjUsYAzJyoIa65EXmp7EHuBeSw==
X-Received: by 2002:a05:6512:3b0d:b0:53b:205c:e979 with SMTP id 2adb3069b0e04-53b236ddd54mr1093168e87.12.1729793421920;
        Thu, 24 Oct 2024 11:10:21 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22431523sm1418601e87.235.2024.10.24.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:07 +0300
Message-ID: <20241024181007.7919-1-vladimirputin693389@gmail.com>
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
