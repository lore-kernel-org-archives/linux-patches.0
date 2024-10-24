Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A871D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793407; cv=none; b=dfJOdK0+WG+NHQ+OoFpBWz0MdFdfC1SnYAfwWjiy23xazjRktVpzkWq3eGpluv+IVRL8udEQ8leVlE81c5db+6NNSO7Y8qmyXPAs9E5aoSSOQuYd8WeJTOrYD17cb5ofKQ6loOBQLHp1WdZc/FuryqChriUkNxcz92njf4DmZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793407; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbKvoC/Lsbky7NhOdX8YFzL3WXcy7F2trrrSZq6vlAvJc1qPMWXspXRuMJzo3hSkCNaow1NEQJI33/IYSQ+EbsdfOEb5Ax1jOc/IoeovYZjhJhwA9uXFstwtGSYiGoBPqt5S2hLIY43J+Kmdtlj0mV2cX9KjkoPLg/K/lghPdB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce7tAoQe; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce7tAoQe"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539fbbadf83so1736298e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793404; x=1730398204; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ce7tAoQes5w2P2GA+j7ETitMgsh5Tn6ZFDxC0Rb8p/VBTBEEGxXn64QMGQioWXUTYZ
         koBCyDjN1/xpLoWU8JQAVfQoxD/42Pqosxf4siNjF5O6QhxV873j7DL38qEZGtXyWMTM
         eL+9wz8HZbZJzRPoq4Q6XF/M+UObKdHejv+Gn4lGEL50Gwxg3KgR9VfwWJFSaFWe+sWu
         algTr0uicAAjs9nW5vNvtT+jyXS42RVs2USOuyYqRR177086GnPbhiYdSMW0+yOx8CPi
         YSIa2fsxWsZW3YVbXOKTYGRuVLarXNw+4ML/2WIGBXDAXhtwr7+wsI5AgknNzMzgOamz
         wfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793404; x=1730398204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=j2rN6e3dzCzABkp9nG6tO1mbNeo0AOe0l0xg9hW7O7tnY1YD+AMguNE1E7Ez/mldi6
         +AgARbUe4SIYh6X2OKLX/M2UTBVoTqESw7JszyxKE18xaJ0/sGRbiFs+VajHpwwn6gWl
         XfsZqBhRRT/YfdrYsX7jLnEe9459JwqiadbsPRmG9/rYbVh8lyU6NZK0VaGtrs3rlZfh
         mjfzW3pu9a7OLcf/Dd8+RuPMaWM26Irb2ZX17hJWISgHg9pBap+jBU6a8L0t4BrOU887
         FlT40n3YZM1s1g5C69ws1QAhjcEoHkhNXlBGjNQ2Rjn7CYIGG2FeAr7UmJtFVNAjRtkf
         /nlA==
X-Gm-Message-State: AOJu0YzMPMCBL4u2UDW3FnYIZhrRTcKNrPxazVFudE/Ic0oGJzt0Dxoa
	46ASfCCEQe+A/oU3pEIO294Pkc5tKqKyHVqPngW4mcQuMIVhIbmt
X-Google-Smtp-Source: AGHT+IH8g8vqaKHeO+1zH0l+l8ymh0qjEFu1g7dtpJITlWEuGF9esxcMbzvjqBg9rZer7uMZ6hURGg==
X-Received: by 2002:ac2:4e08:0:b0:539:fc86:ce0e with SMTP id 2adb3069b0e04-53b1a341b11mr3930373e87.35.1729793403672;
        Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22431b33sm1424468e87.214.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:50 +0300
Message-ID: <20241024180950.5171-1-vladimirputin693389@gmail.com>
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
