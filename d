Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF63200B83
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793392; cv=none; b=b5mNCBmpswhPQk4SKdJOsTG2jxV/uOcz2yV6GAtsGWs4M8L60Uk4zJymw55MTP0tiHjWB7JeB1e3c18Fn3jXZYm+SgWIDhAlk9y+99wCEm7N0aTll6SIN030v29VzE4Yl9GSKv0dSTKuxulSUEwij6BJq4rhpOL3uIfNw9ZxqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793392; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdCR4NHLdqKP6pbwAgGjROmjdG0fMQIk0qrF0DV4BcJ024vgj98uJTf9zi0/fr2cDeCJzl23A/QfBtvvwx3NYeArizC8FTU2otHx//str1xjAvY402Q/ROemb9JAHZzLjrD2t2KFW2ck4jal/h/M4faCG9vJhm62eGdEImOmM4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOA51uiw; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOA51uiw"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so13063611fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793388; x=1730398188; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YOA51uiwvR0k6f420MzXlSt/XNQCXXUtU8IyXvzXlh/zdxEaFyb7rSn5rkbu4RIt9o
         C6UoDqXBScLgQ69IfwOYTOaU7j09GapKAiR3eepFJ7WfYWPHHsFm++tsk1i10F4hrzOX
         dzaBZv+Z0Cfjq9wQvmYxE9JLkEMZ80ml9//IdU87vot1/ofI7a9FSfIsjQY+Z6LhdJIa
         wd0+uqpmZEh4DbQOhbcjCn2yVfWbX+jGz70Ig8T4Yo9jdwIqLXZl2A35b6QXZ0RAsgl3
         AYguYYRgBkJO3zxWFvLO70H7/ZSAyS6V1OzTQuPz4Me88d0j2xh8efWAy7E9E2MhZCjd
         cqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793388; x=1730398188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=JERiH68AFwqThyYy0Y9x194PrThpNUL5RiSUIRXpHNUAmWH8baj7vJ/FkFZFqEO1w7
         j4Gu6PDFTbxUGLydQG2U5ydiyym5ft375bCg7Q8/47X3IMwSvjyW0KQUK3LJ4WuOOFyw
         t5n9yQm2gbe5AL7+aVciWxPwRIzm1JLHSljCHVzVrddT1RV69FhlfLaBwJiC6lP6p/tp
         PEADE/0QBoLM2tUkh7Pfeuxd9RBfDBpZAZFyxQa2uaagyzgKTT+JrkFsyBII2I0Q5/vg
         x3Wk55U7I1OSTP3Pg51te/oObGdcVPNRoS4id445dShfQpeaBTDnyFTSw+gM6WNB6VQi
         ix1g==
X-Gm-Message-State: AOJu0Yz+jRiv+tarlZwTtR+7Q4B5Lmvbv6OUuAZyQCGCeb862UQ1+kBz
	OH5nmAxBfEar/CpW+mOEcfLTXB4KL/lwSdZ2/vs6Nl+IX3RDvlNq
X-Google-Smtp-Source: AGHT+IHsbDHySavHrHZicxmtm3RESrhJqscqraDyuo0u6tVvva1ARzMa8Rqqa6Hya6TUFLWhJ7jFQQ==
X-Received: by 2002:a2e:6112:0:b0:2fb:5035:a03 with SMTP id 38308e7fff4ca-2fc9d349e0cmr36307391fa.14.1729793387704;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad6100fsm14549241fa.39.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3584-1-vladimirputin693389@gmail.com>
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
